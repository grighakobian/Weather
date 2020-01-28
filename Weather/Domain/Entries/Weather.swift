//
//  Weather.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct Weather: Decodable {
    public var weatherList: [WeatherListItem]
    public var city: City
    
    public init(list: [WeatherListItem],
                city: City) {
        
        self.weatherList = list
        self.city = city
    }
    
    enum CodingKeys: String, CodingKey {
        case city
        case weatherList = "list"
    }
}
