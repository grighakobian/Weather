//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxCoreLocation
import CoreLocation

public final class WeatherViewModel: ViewModelType {
    
    struct Input {
        let locationTrigger: Driver<CLLocation?>
        let searchQueryTrigger: Driver<String>
        let searchResultSelection: Driver<IndexPath>
    }
    
    struct Output {
        let placemarks: Driver<[CLPlacemark]>
        let weatherItemViewModel: Driver<WeatherItemViewModel>
        let error: Driver<Error>

    }
    
    let useCase: WeatherUseCase
    let geocoder = CLGeocoder()
    
    init(useCase: WeatherUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: WeatherViewModel.Input) -> WeatherViewModel.Output {
        let errorTracker = ErrorTracker()
        
        let placemarks = input.searchQueryTrigger.flatMapLatest {
            return self.geocoder.rx
                .geocode(addressString: $0)
                .asDriver(onErrorJustReturn: [])
        }
        
        let selectedPlacemark = input.searchResultSelection
            .withLatestFrom(placemarks) { (indexPath, placemarks) -> CLLocation? in
                return placemarks[indexPath.row].location
        }
        
        let weatherItemViewModel = Driver
            .merge(input.locationTrigger, selectedPlacemark)
            .filter({ $0 != nil })
            .map({ $0!.coordinate })
            .flatMapLatest {
                self.useCase
                    .getWeatherByLocation(lat: $0.latitude, lon: $0.longitude)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .map({ (weather) -> WeatherItemViewModel in
                        return WeatherItemViewModel(with: weather)
                    })
        }
        
        let error = errorTracker.asDriver()
        
        return Output(
            placemarks: placemarks,
            weatherItemViewModel: weatherItemViewModel,
            error: error
        )
    }
}

