//
//  StickyHeaderView.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public final class StickyHeaderView: UIView {
    
    @IBOutlet weak var ibPlaceLabel: UILabel!
    @IBOutlet weak var ibTempLabel: UILabel!
    @IBOutlet weak var ibDescLabel: UILabel!
    @IBOutlet weak var ibWeekdayLabel: UILabel!
    @IBOutlet weak var ibTodayLabel: UILabel!
    @IBOutlet weak var ibTempMaxLabel: UILabel!
    @IBOutlet weak var ibTempMinLabel: UILabel!
    @IBOutlet weak var ibSearchButton: UIButton!
    @IBOutlet weak var ibStackView: UIStackView!
    @IBOutlet weak var ibStackViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var ibCollectionView: UICollectionView!
    
    private var layoutSubviewsOnce = false
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        ibCollectionView.register(HourlyWeatherCell.self)
    }
    
    func update(with percentage: CGFloat) {
        let minPercentage = (percentage - 0.7) / (1 - 0.7)
        let maxPercentage = (percentage - 0.5) / (1 - 0.5)
        ibTempMaxLabel.alpha = minPercentage
        ibTempMinLabel.alpha = minPercentage
        ibTodayLabel.alpha = minPercentage
        ibWeekdayLabel.alpha = minPercentage
        ibTempLabel.alpha = maxPercentage
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let insetTop = UIApplication.shared.keyWindow?.safeAreaInsets.top {
            ibSearchButton.topAnchor.constraint(equalTo: topAnchor, constant: insetTop).isActive = true
        }
        
        if (layoutSubviewsOnce == false) {
            layoutSubviewsOnce = true
            ibStackViewTopContraint.constant = ibStackView.frame.origin.y
        }
    }
}


// MARK: - Bindable

extension StickyHeaderView: Bindable {
    public typealias Item = WeatherItemModel
    
    public func bind(item: WeatherItemModel) {
        ibTempLabel.text    = String(format: "%.f°", item.temp)
        ibTempMaxLabel.text = String(format: "%.f", item.tempMax)
        ibTempMinLabel.text = String(format: "%.f", item.tempMin)
        ibDescLabel.text    = item.description
        ibPlaceLabel.text   = item.city.name
        ibTodayLabel.text   = NSLocalizedString("TODAY", comment: "").uppercased()
        ibWeekdayLabel.text = item.date.weekdayName(.default)
    }
}
