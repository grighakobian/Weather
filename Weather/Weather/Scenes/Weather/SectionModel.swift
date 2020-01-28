//
//  DataSource.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/21/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift
import Differentiator
import Domain


enum WeatherSectionModel {
    case nextDaysSection(items: [WeatherItemModel])
    case descriptionSection(items: [WeatherItemModel])
    case informationSection(items: [WeatherItemModel])
}


extension WeatherSectionModel: SectionModelType {
    typealias Item = WeatherItemModel
    
    var items: [WeatherItemModel] {
        switch  self {
        case .nextDaysSection(let items):
            return items.map {$0}
        case .descriptionSection(let items):
            return items.map {$0}
        case .informationSection(let items):
            return items.map {$0}
        }
    }
    
    init(original: WeatherSectionModel, items: [Item]) {
        switch original {
        case .nextDaysSection(let items):
            self = .nextDaysSection(items: items)
        case .descriptionSection(let items):
            self = .descriptionSection(items: items)
        case .informationSection(let items):
            self = .informationSection(items: items)
        }
    }
}
