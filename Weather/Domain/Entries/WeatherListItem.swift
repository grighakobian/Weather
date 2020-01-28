//
//  List.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct WeatherListItem: Decodable {
    /// Time of data forecasted, unix, UTC
    public let date: Date
    /// Weather Main info
    public let main: Main
    /// Weaher data for next 5 days
    public let weatherInfoList: [WeatherInfo]
    /// Weather Clouds info
    public let clouds: Clouds
    /// Weather Wind info
    public let wind: Wind
    /// Weather Sys info
    public let sys: Sys?
    /// Weather Rain info
    public let rain: Rain?
    /// Weather Snow info
    public let snow: Snow?
    /// Data/time of calculation, UTC
    public let dtTxt: String
    
    public init(date: Date,
                main: Main,
                weatherInfoList: [WeatherInfo],
                clouds: Clouds,
                wind: Wind,
                sys: Sys?,
                rain: Rain?,
                snow: Snow?,
                dtTxt: String) {
        
        self.date = date
        self.main = main
        self.weatherInfoList = weatherInfoList
        self.clouds = clouds
        self.wind = wind
        self.sys = sys
        self.rain = rain
        self.snow = snow
        self.dtTxt = dtTxt
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, main, clouds, wind, sys, rain, snow
        case weatherInfoList = "weather"
        case dtTxt = "dt_txt"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dt = try container.decode(Double.self, forKey: .dt)
        date = Date(timeIntervalSince1970: dt)
        main = try container.decode(Main.self, forKey: .main)
        weatherInfoList = try container.decode([WeatherInfo].self, forKey: .weatherInfoList)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        wind = try container.decode(Wind.self, forKey: .wind)
        sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
        rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        snow = try container.decodeIfPresent(Snow.self, forKey: .snow)
        dtTxt = try container.decode(String.self, forKey: .dtTxt)
    }
}
