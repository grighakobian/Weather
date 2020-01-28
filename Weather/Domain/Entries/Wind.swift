//
//  Wind.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct Wind: Decodable {
    /// Wind speed. Unit Default: meter/sec,
    /// Metric: meter/sec, Imperial: miles/hour.
    public let speed: Double
    /// Wind direction, degrees (meteorological)
    public let degrees: Double
    
    public init(speed: Double,
                degrees: Double) {
        
        self.speed = speed
        self.degrees = degrees
    }
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
}
