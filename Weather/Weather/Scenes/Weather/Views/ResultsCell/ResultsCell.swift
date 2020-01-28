//
//  ResultsCell.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/22/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit
import CoreLocation

final class ResultsCell: UITableViewCell, Bindable {
    typealias Item = CLPlacemark
    
    func bind(item: CLPlacemark) {
        textLabel?.text = item.name
        backgroundColor = .clear
        textLabel?.textColor = .white
        selectedBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    }
}
