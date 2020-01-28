//
//  WeatherInfoCell.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/20/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import Domain

final class WeatherInfoCell: UITableViewCell {
    
    @IBOutlet weak var ibHumidityLabel: UILabel!
    @IBOutlet weak var ibHumidityValueLabel: UILabel!
    @IBOutlet weak var ibPressureLabel: UILabel!
    @IBOutlet weak var ibPressureValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

// MARK: - Bindable

extension WeatherInfoCell: Bindable {
    typealias Item = WeatherItemModel
    
    func bind(item: WeatherItemModel) {
        ibHumidityValueLabel.text = item.humidity
        ibPressureValueLabel.text = item.pressure
    }
}
