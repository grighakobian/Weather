//
//  WeatherItemModel.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/20/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation
import Domain
import SwiftDate
import RxCocoa
import RxSwift


public final class WeatherItemModel {
    
    var date: Date
    var temp: Double
    var tempMax: Double
    var tempMin: Double
    var description: String
    var main: String
    var icon: String
    var pressure: String
    var humidity: String
    var items: [WeatherListItem]
    var city: City
    
    init(city: City, items: [WeatherListItem]) {
        self.city = city
        self.items = items
        
        let mainItem = items[0]
        let weatherInfo = mainItem.weatherInfoList[0]
        temp = mainItem.main.temp
        date = mainItem.date
        description = weatherInfo.description.capitalized
        main = weatherInfo.main
        icon = weatherInfo.icon
        pressure = String(format: "%.f %@", mainItem.main.pressure, UnitPressure.hectopascals.symbol)
        humidity = String(format: "%.f %%", mainItem.main.humidity)
        
        tempMax = items.sorted{ $0.main.tempMax > $1.main.tempMax }[0].main.tempMax
        tempMin = items.sorted{ $0.main.tempMin < $1.main.tempMin }[0].main.tempMin
    }
}


public final class WeatherItemViewModel {

    var mainInfo: Driver<WeatherItemModel>
    var hourlyInfo: Driver<[WeatherListItem]>
    var sections: Driver<[WeatherSectionModel]>
    
    init(with weather: Weather) {
        let city = weather.city
        
        let dailyWeatherList = weather.weatherList.chunked(into: 8)
        var dailyWeatherItemModels = dailyWeatherList.map({ WeatherItemModel(city: city, items: $0) })
        let todayWeatherItemModel = dailyWeatherItemModels.removeFirst()
        
        mainInfo = Driver.just(todayWeatherItemModel)
        hourlyInfo = Driver.of(todayWeatherItemModel.items)

        let sectionModels: [WeatherSectionModel] = [
            .nextDaysSection(items: dailyWeatherItemModels),
            .descriptionSection(items: [todayWeatherItemModel]),
            .informationSection(items: [todayWeatherItemModel])
        ]
        sections = Driver.just(sectionModels)
    }
}
