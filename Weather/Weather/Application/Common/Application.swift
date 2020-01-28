//
//  Application.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation
import Domain
import NetworkPlatform

final class Application {
    static let shared = Application()
    
    private let networkUseCaseProvider: Domain.UseCaseProvider
    
    private init() {
        self.networkUseCaseProvider = NetworkPlatform.UseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let navigationController = UINavigationController()
        let networkNavigator = DefaultWeatherNavigator(
            useCaseProvider: networkUseCaseProvider,
            navigationController: navigationController
        )
        window.rootViewController = navigationController
        networkNavigator.toWeather()
    }
}

