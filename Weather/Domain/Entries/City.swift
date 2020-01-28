//
//  City.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct City: Decodable {
    /// City ID
    public let id: Int
    /// City name
    public var name: String
    /// City geo location
    public let location: Location
    /// Country code (GB, JP etc.)
    public let country: String
    
    public init(id: Int,
                name: String,
                location: Location,
                country: String) {
        
        self.id = id
        self.name = name
        self.location = location
        self.country = country
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, country
        case location = "coord"
    }
}
