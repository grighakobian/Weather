//
//  ViewModelType.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/19/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
