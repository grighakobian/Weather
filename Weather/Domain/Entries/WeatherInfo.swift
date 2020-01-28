//
//  WeatherInfo.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct WeatherInfo: Decodable {
    /// Weather condition id
    public let id: Int
    /// Group of weather parameters (Rain, Snow, Extreme etc.)
    public let main: String
    /// Weather condition within the group
    public let description: String
    /// Weather icon id
    public let icon: String
    
    public init(id: Int,
                main: String,
                description: String,
                icon: String) {
        
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}
