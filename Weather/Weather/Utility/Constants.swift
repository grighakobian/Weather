//
//  Constants.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/21/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation
import QuartzCore

enum Constants {
    static let weatherProviderURL = URL(string: "https://openweathermap.org/")!
    static let stickyHeaderHeightCoefficient: CGFloat = 384/667
    static let stickyHeaderHeight: CGFloat = 384
    static let stickyHeaderMinHeight: CGFloat = 250
}
