//
//  Snow.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct Snow: Decodable {
    /// Snow volume for last 3 hours
    public let volume: Double?
    
    public init(volume: Double?) {
        self.volume = volume
    }
    
    enum CodingKeys: String, CodingKey {
        case volume = "3h"
    }
    
    public init(from decoder: Decoder) throws {
        guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
            self.volume = nil
            return
        }
        volume = try container.decodeIfPresent(Double.self, forKey: .volume)
    }
}

