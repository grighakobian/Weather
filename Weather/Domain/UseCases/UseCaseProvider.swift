//
//  UseCaseProvider.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
    
    func makeWeatherUseCase() -> WeatherUseCase
}


