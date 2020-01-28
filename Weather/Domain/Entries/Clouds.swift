//
//  Clouds.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public struct Clouds: Decodable {
    /// Cloudiness, %
    public let all: Int
    
    public init(all: Int) {
        self.all = all
    }
}
