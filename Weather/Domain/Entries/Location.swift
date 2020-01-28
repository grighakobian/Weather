//
//  Location.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct Location: Decodable {
    /// Geo location latitude
    public let latitude: Double
    /// Geo location longitude
    public let longitude: Double
    
    public init(latitude: Double,
                longitude: Double) {
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
