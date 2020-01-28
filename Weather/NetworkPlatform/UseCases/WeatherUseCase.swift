//
//  WeatherUseCase.swift
//  NetworkPlatform
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation
import Domain
import RxSwift

final class WeatherUseCase: Domain.WeatherUseCase {
    private let network: WeatherNetwork
    
    init(network: WeatherNetwork) {
        self.network = network
    }
    
    func getWeatherByCityName(_ name: String, countryCode: String) -> Observable<Weather> {
        return network.getWeatherByCityName(name, countryCode: countryCode)
    }
    
    func getWeatherByCityID(_ id: Int) -> Observable<Weather> {
        return network.getWeatherByCityID(id)
    }
    
    func getWeatherByZipCode(_ zipCode: Int) -> Observable<Weather> {
        return network.getWeatherByZipCode(zipCode)
    }
    
    func getWeatherByLocation(lat: Double, lon: Double) -> Observable<Weather> {
        return network.getWeatherByLocation(lat: lat, lon: lon)
    }
}
