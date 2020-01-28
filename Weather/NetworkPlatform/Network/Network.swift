//
//  Network.swift
//  NetworkPlatform
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import RxSwift
import Moya
import Result

public final class Network<T: TargetType, D: Decodable> {
    private let provider: MoyaProvider<T>
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    public init() {
        let plugin = NetworkLoggerPlugin()
        self.provider = MoyaProvider<T>(plugins: [plugin])
        let qos = DispatchQoS(qosClass: .background, relativePriority: 1)
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
    }
    
    public func request(token: T)->Observable<D> {
        return provider.rx
            .request(token)
            .observeOn(scheduler)
            .map(D.self)
            .asObservable()
    }
}

