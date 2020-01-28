//
//  WeatherUseCase.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import RxSwift

public protocol WeatherUseCase {

    func getWeatherByCityName(_ name: String, countryCode: String)-> Observable<Weather>
    func getWeatherByCityID(_ id: Int)-> Observable<Weather>
    func getWeatherByZipCode(_ zipCode: Int)-> Observable<Weather>
    func getWeatherByLocation(lat: Double, lon: Double)-> Observable<Weather>
}
