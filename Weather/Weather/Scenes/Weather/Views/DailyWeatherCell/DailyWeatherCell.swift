//
//  DailyWeatherCell.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import Domain
import Kingfisher

final class DailyWeatherCell: UITableViewCell {
    
    @IBOutlet weak var ibWeekdayLabel: UILabel!
    @IBOutlet weak var ibTempMaxLabel: UILabel!
    @IBOutlet weak var ibTempMinLabel: UILabel!
    @IBOutlet weak var ibImageView: UIImageView!

}

// MARK: - Bindable

extension DailyWeatherCell: Bindable {
    typealias Item = WeatherItemModel
    
    func bind(item: WeatherItemModel) {
        ibWeekdayLabel.text = item.date.weekdayName(.default)
        ibTempMaxLabel.text = String(format: "%.f", item.tempMax)
        ibTempMinLabel.text = String(format: "%.f", item.tempMin)
        let url = Utility.getIconUrl(from: item.icon)
        ibImageView.kf.setImage(with: url)
    }
}
