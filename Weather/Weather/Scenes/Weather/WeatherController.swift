//
//  WeatherController.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import RxDataSources
import MapKit

public final class WeatherController: UITableViewController {
    
    private var viewModel: WeatherViewModel!
    private var locationManager: CLLocationManager!
    private var searchController: UISearchController!
    private var resultsController: UITableViewController!
    private var stickyHeaderView: StickyHeaderView!
    private var stickyHeaderHeight = Constants.stickyHeaderHeight
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    
    public convenience init(viewModel: WeatherViewModel) {
        self.init(style: .plain)
        
        self.viewModel = viewModel
        commonInit()
    }
    
    private override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureTableViewBackground()
        configureStickyHeaderView()
        configureNavigationBar()
        configureNavigationItem()
        
//        bindViewModel()
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround
        if (navigationController?.navigationBar.alpha == 0) {
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.navigationBar.alpha = 1
        }
    }
    
    // MARK: - Methods
    
    private func initSeachController() {
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.tintColor = .white
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchController.rx.willDismiss
            .bind { self.setNavigationBarHidden(true) }
            .disposed(by: disposeBag)
    }
    
  private func initResultsController() {
        resultsController = UITableViewController(style: .plain)
        resultsController.tableView.rowHeight = 44.0
        resultsController.tableView.separatorInset.left = 44.0
        resultsController.tableView.separatorStyle = .none
        resultsController.tableView.backgroundColor = .clear
        resultsController.tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        resultsController.tableView.register(ResultsCell.self, forCellReuseIdentifier: ResultsCell.reuseID)
        resultsController.tableView.delegate = nil
        resultsController.tableView.dataSource = nil
        resultsController.tableView.rx.itemSelected
            .bind { _ in self.resignSearchControllerActive() }
            .disposed(by: disposeBag)
    }
    
    private func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50.0
        locationManager.rx.didChangeAuthorization
            .subscribe(onNext: { manager , status in
                self.handleAuthorizationStatus(status)
            })
            .disposed(by: disposeBag)
    }
    
    private func initStickyHeaderView() {
        stickyHeaderView = StickyHeaderView.fromNib()
        stickyHeaderView.ibSearchButton.rx.tap
            .bind { self.recomeSearchControllerActive() }
            .disposed(by: disposeBag)
    }
    
    private func commonInit() {
        initLocationManager()
        initResultsController()
        initSeachController()
        initStickyHeaderView()
    }
    
    private func resignSearchControllerActive() {
        searchController.isActive = false
        searchController.searchBar.resignFirstResponder()
    }
    
    private func recomeSearchControllerActive() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        searchController.searchBar.becomeFirstResponder()
    }
    
    private func setNavigationBarHidden(_ hidden: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: true)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            self.showLocationServicesDisabledAlert()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        let searchQueryTrigger = searchController.searchBar.rx
            .text
            .throttle(0.3, scheduler: MainScheduler.instance)
            .map { ($0 ?? String()).trimmingCharacters(in: .whitespaces) }
            .skipWhile({ $0.isEmpty })
            .asDriver(onErrorJustReturn: String())
        
        let locationTrigger = locationManager.rx
            .location
            .debug()
            .asDriverOnErrorJustComplete()
        
        locationManager.rx
            .location
            .subscribe { (next) in
                self.locationManager.stopUpdatingLocation()
            }.disposed(by: disposeBag)
        
        let searchResultSelection = resultsController.tableView.rx
            .itemSelected
            .asDriver()
        
        let input = WeatherViewModel.Input(
            locationTrigger: locationTrigger,
            searchQueryTrigger: searchQueryTrigger,
            searchResultSelection: searchResultSelection
        )
        
        let output = viewModel.transform(input: input)

        output.placemarks
            .drive(self.resultsController.tableView.rx
                .items(cellIdentifier: ResultsCell.reuseID, cellType: ResultsCell.self)) { _, placemark, cell in
                   cell.bind(item: placemark)
            }
            .disposed(by: disposeBag)
        
        output.weatherItemViewModel
            .flatMapLatest({ $0.mainInfo })
            .asObservable()
            .bind { self.stickyHeaderView.bind(item: $0) }
            .disposed(by: disposeBag)
        
        output.weatherItemViewModel
            .flatMapLatest({ $0.hourlyInfo })
            .drive(self.stickyHeaderView.ibCollectionView.rx.items(cellIdentifier: HourlyWeatherCell.reuseID, cellType: HourlyWeatherCell.self)) { _, item, cell in
                cell.bind(item: item)
            }
            .disposed(by: disposeBag)
        
        output.weatherItemViewModel
            .flatMapLatest({ $0.sections })
            .drive(self.tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        output.error.drive(onNext: { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }).disposed(by: disposeBag)
    }
    
    
    private func configureTableViewBackground() {
        // Background View
        let backgroundView = UIView()
        // Image View
        let image = UIImage(named:"img_weather_background")!
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Blur Effect View
        let blur = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(imageView)
        backgroundView.addSubview(blurEffectView)
        tableView.backgroundView = backgroundView
        imageView.pinToSuperview()
        blurEffectView.pinToSuperview()
    }
    
    private func configureStickyHeaderView() {
        let safeAreaInsets = UIApplication.shared.keyWindow!.safeAreaInsets
        let screenHeight = UIApplication.shared.keyWindow!.bounds.height
        let topSafeArea    = safeAreaInsets.top
        let bottomSafeArea = safeAreaInsets.bottom
        
        let safeAreaTotalInset = topSafeArea + bottomSafeArea
        let safeAreaHeight = screenHeight - safeAreaTotalInset
        let coefficient = Constants.stickyHeaderHeightCoefficient
        stickyHeaderHeight = (coefficient * safeAreaHeight) + safeAreaTotalInset
        stickyHeaderHeight = max(Constants.stickyHeaderHeight, stickyHeaderHeight)
        stickyHeaderHeight = floor(stickyHeaderHeight)
        
        tableView.contentInset.top          = stickyHeaderHeight
        tableView.scrollIndicatorInsets.top = stickyHeaderHeight
        
        var stickyHeaderFrame         = tableView.bounds
        stickyHeaderFrame.size.height = stickyHeaderHeight
        stickyHeaderFrame.origin.y    = -stickyHeaderHeight
        stickyHeaderView.frame        = stickyHeaderFrame
        tableView.addSubview(stickyHeaderView)
    }
    
    private func configureTableView() {
        tableView.dataSource = nil
        tableView.delegate = nil

        tableView.register(DailyWeatherCell.self)
        tableView.register(WeatherDescriptionCell.self)
        tableView.register(WeatherInfoCell.self)

        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        // Workaround
        let insetBottom = tableView.bounds.height - Constants.stickyHeaderMinHeight * 2
        self.tableView.contentInset.bottom = insetBottom
        
        tableView.rx.contentOffset.map({ $0.y })
            .subscribe(onNext: { yOffset in
                self.handleScroll(with: yOffset)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleScroll(with yOffset: CGFloat) {
        // Pin Sticky header on top
        let minHeaderHeight = Constants.stickyHeaderMinHeight
        var headerFrame = stickyHeaderView.frame
        var headerCurrentHeight = abs(yOffset)
        headerCurrentHeight = max(minHeaderHeight, headerCurrentHeight)
        headerFrame.origin.y = yOffset
        headerFrame.size.height = headerCurrentHeight
        stickyHeaderView.frame = headerFrame
        // Update Sticky header
        var percentage = (headerCurrentHeight - minHeaderHeight) / (stickyHeaderHeight - minHeaderHeight)
        percentage = max(0, percentage)
        percentage = min(percentage, 1)
        stickyHeaderView.update(with: percentage)
        // Masking cells
        tableView.visibleCells.forEach { (cell) in
            let marginTop = yOffset + headerCurrentHeight - cell.frame.origin.y
            if (marginTop >= 0 || marginTop <= cell.frame.height) {
                cell.mask(with: marginTop)
            }
        }
    }
    
    private func configureNavigationBar() {
        let navigationBar = navigationController!.navigationBar
        navigationBar.alpha = 0
        navigationBar.barStyle = .black
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ]
    }
    
    private func configureNavigationItem() {
        navigationItem.title = NSLocalizedString("weather.search-hint", comment: "")
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    private func showLocationServicesDisabledAlert() {
        let title = NSLocalizedString("alert.title.location-service-disabled", comment: "")
        let message = NSLocalizedString("alert.message.location-service-disabled", comment: "")
        let okActionTitle = NSLocalizedString("alert.ok-action-title", comment: "")
        let settingsActionTitle = NSLocalizedString("alert.settings-action-title", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: settingsActionTitle, style: .cancel, handler: { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        alert.addAction(okAction)
        alert.addAction(settingsAction)
        present(alert, animated: true)
    }
}


// MARK: - RxTableViewSectionedReloadDataSource

extension WeatherController {
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<WeatherSectionModel> {
        return RxTableViewSectionedReloadDataSource<WeatherSectionModel>(
            configureCell: { (dataSource, table, idxPath, _) in
                let section = dataSource[idxPath.section]
                switch section {
                case .nextDaysSection(let items):
                    let cell = table.dequeueReusableCell(ofType: DailyWeatherCell.self, at: idxPath)
                    let item = items[idxPath.row]
                    cell.bind(item: item)
                    return cell
                case .descriptionSection(let items):
                    let cell = table.dequeueReusableCell(ofType: WeatherDescriptionCell.self, at: idxPath)
                    let item = items[idxPath.row]
                    cell.bind(item: item)
                    return cell
                case .informationSection(let items):
                    let cell = table.dequeueReusableCell(ofType: WeatherInfoCell.self, at: idxPath)
                    let item = items[idxPath.row]
                    cell.bind(item: item)
                    return cell
                }
        })
    }
}
