//
//  WeatherNetworkProvider.swift
//  NetworkPlatform
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Domain
import RxSwift
import Moya


public final class WeatherNetwork {
    private let network: Network<OpenWeatherMapApi, Weather>
    
    init(network: Network<OpenWeatherMapApi, Weather>) {
        self.network = network
    }
    
    public func getWeatherByCityName(_ name: String, countryCode: String)-> Observable<Weather> {
        return network.request(token: .weatherByCityName(name: name, countryCode: countryCode))
    }
    public func getWeatherByCityID(_ id: Int)-> Observable<Weather> {
        return network.request(token: .weatherByCityID(id: id))
    }
    
    public func getWeatherByZipCode(_ zipCode: Int)-> Observable<Weather> {
        return network.request(token: .weatherByZipCode(zipCode: zipCode))
    }
    
    public func getWeatherByLocation(lat: Double, lon: Double)-> Observable<Weather> {
        return network.request(token: .weatherByLocation(lat: lat, lon: lon))
    }
}
