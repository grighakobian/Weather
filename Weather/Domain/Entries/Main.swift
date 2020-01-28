//
//  Main.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct Main: Decodable {
    /// Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    public let temp : Double
    ///  Minimum temperature at the moment of calculation. This is deviation
    ///  from 'temp' that is possible for large cities and megalopolises
    ///  geographically expanded (use these parameter optionally).
    ///  Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    public let tempMin : Double
    /// Maximum temperature at the moment of calculation.
    /// This is deviation from 'temp' that is possible for large
    /// cities and megalopolises geographically expanded (use these parameter optionally).
    /// Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    public let tempMax: Double
    /// Atmospheric pressure on the sea level by default, hPa
    public let pressure: Double
    /// Atmospheric pressure on the sea level, hPa
    public let seaLevel: Double
    /// Atmospheric pressure on the ground level, hPa
    public let grndLevel: Double
    /// Humidity, %
    public let humidity: Double
    /// Internal parameter
    public let tempKf: Double
    
    public init(temp: Double,
                tempMin: Double,
                tempMax: Double,
                pressure: Double,
                seaLevel: Double,
                grndLevel: Double,
                humidity: Double,
                tempKf: Double) {
        
        self.temp = temp
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.seaLevel = seaLevel
        self.grndLevel = grndLevel
        self.humidity = humidity
        self.tempKf = tempKf
    }
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}
