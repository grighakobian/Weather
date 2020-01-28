//
//  Utility.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/22/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public final class Utility {
    
    class func getIconUrl(from icon: String)->URL {
        return URL(string: "https://openweathermap.org/img/w/\(icon).png")!
    }
}
