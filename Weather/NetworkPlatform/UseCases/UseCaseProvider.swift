//
//  UseCaseProvider.swift
//  NetworkPlatform
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let networkProvider: NetworkProvider
    
    public init() {
        networkProvider = NetworkProvider()
    }
    
    public func makeWeatherUseCase() -> Domain.WeatherUseCase {
        let network = networkProvider.makeWeatherNetwork()
        return WeatherUseCase(network: network)
    }
}
