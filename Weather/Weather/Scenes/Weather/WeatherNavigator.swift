//
//  WeatherNavigator.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation
import Domain
import CoreLocation

protocol WeatherNavigator {
    func toWeather()
}

class DefaultWeatherNavigator: WeatherNavigator {
   
    private let navigationController: UINavigationController
    private let useCaseProvider: UseCaseProvider
    
    init(useCaseProvider: UseCaseProvider, navigationController: UINavigationController) {
        self.useCaseProvider = useCaseProvider
        self.navigationController = navigationController
    }
    
    func toWeather() {
        let useCase = useCaseProvider.makeWeatherUseCase()
        let viewModel = WeatherViewModel(useCase: useCase)
        let weatherController = WeatherController(viewModel: viewModel)
        navigationController.setViewControllers([weatherController], animated: false)
    }
}
