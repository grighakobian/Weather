//
//  NetworkProvider.swift
//  NetworkPlatform
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Domain
import Moya

public final class NetworkProvider {
    public init() {}
    
    public func makeWeatherNetwork() -> WeatherNetwork {
        let network = Network<OpenWeatherMapApi, Weather>()
        let weatherNetwork = WeatherNetwork(network: network)
        return weatherNetwork
    }
}
