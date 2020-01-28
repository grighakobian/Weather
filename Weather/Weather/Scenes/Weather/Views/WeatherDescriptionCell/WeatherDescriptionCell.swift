//
//  WeatherDescriptionCell.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import Domain

final class WeatherDescriptionCell: UITableViewCell {
    @IBOutlet weak var ibDescriptionLabel: UILabel!
}

// MARK: - Bindable

extension WeatherDescriptionCell: Bindable {
    typealias Item = WeatherItemModel
    
    func bind(item: WeatherItemModel) {
        let key = NSLocalizedString("weather.description", comment: "")
        let info = item.description
        let temp = item.temp
        let tempMax = item.tempMax
        ibDescriptionLabel.text = String(format: key, info, temp, tempMax)
    }
}
