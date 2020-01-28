//
//  Array+Chunk.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/22/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
