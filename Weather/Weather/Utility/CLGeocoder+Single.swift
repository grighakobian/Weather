//
//  CLGeocoder+Single.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/22/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import RxSwift
import CoreLocation

extension Reactive where Base: CLGeocoder {
    
    func geocode(addressString: String)->Single<[CLPlacemark]> {
        return Single<[CLPlacemark]>.create { [weak base] (single) -> Disposable in
            base?.cancelGeocode()
            base?.geocodeAddressString(addressString) { (placemarks, error) in
                guard let placemarks = placemarks, error == nil else {
                    single(.error(error!))
                    return
                }
                single(.success(placemarks))
            }
            return Disposables.create { base?.cancelGeocode() }
        }
    }
}
