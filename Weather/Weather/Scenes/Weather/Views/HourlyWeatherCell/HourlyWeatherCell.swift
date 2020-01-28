//
//  HourlyWeatherCell.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/22/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import Domain

public final class HourlyWeatherCell: UICollectionViewCell {

    @IBOutlet weak var ibDateLabel: UILabel!
    @IBOutlet weak var ibTempLabel: UILabel!
    @IBOutlet weak var ibImageView: UIImageView!
    
}

// MARK: - Bindable

extension HourlyWeatherCell: Bindable {
    public typealias Item = WeatherListItem
    
    public func bind(item: WeatherListItem) {
        let dateString = item.date.toFormat("hha")
        let attributedString = NSMutableAttributedString(
            string: dateString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.white
            ])
        let rangeAM = (dateString as NSString).range(of: "AM")
        let rangePM = (dateString as NSString).range(of: "PM")
        let range = rangeAM.length > 0 ? rangeAM : rangePM
        attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 13, weight: .medium)], range: range)
        
        ibDateLabel.attributedText = attributedString
        ibTempLabel.text = String(format: "%.f°", item.main.temp)
        let icon = item.weatherInfoList.first!.icon
        let url = Utility.getIconUrl(from: icon)
        ibImageView.kf.setImage(with: url)
    }
}
