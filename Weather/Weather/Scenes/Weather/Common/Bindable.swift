//
//  Bindable.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/22/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

public protocol Bindable {
    associatedtype Item
    func bind(item: Item)
}
