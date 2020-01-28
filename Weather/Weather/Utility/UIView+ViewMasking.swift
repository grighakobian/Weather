//
//  UIView+ViewMasking.swift.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/14/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//
// Source https://stackoverflow.com/a/13736305

import UIKit

protocol ViewMasking: class {
    func mask(with margin: CGFloat)
    func visibilityMask(for location: CGFloat)->CAGradientLayer
}

extension UIView: ViewMasking {
    
    func mask(with margin: CGFloat) {
        let location = margin / frame.height
        layer.mask = visibilityMask(for: location)
        layer.masksToBounds = true
    }
    
    func visibilityMask(for location: CGFloat)->CAGradientLayer {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor(white: 1, alpha: 0).cgColor,  UIColor(white: 1, alpha: 1).cgColor]
        mask.locations = [NSNumber(value: Float(location)), NSNumber(value: Float(location))]
        return mask
    }
}
