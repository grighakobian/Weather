//
//  OpenWeatherMap.swift
//  NetworkPlatform
//
//  Created by Grigor Hakobyan on 4/12/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import Moya

struct API {
    private init() {}
    static let baseUrl     = "https://api.openweathermap.org"
    static let dataPath    = "data"
    static let apiVersion  = "2.5"
    static let apiKey      = "6542412d6a736e990475b828b3975de0"
    static let units       = "metric"
}

public enum OpenWeatherMapApi: TargetType {
    
    case weatherByLocation(lat: Double, lon: Double)
    case weatherByZipCode(zipCode: Int)
    case weatherByCityName(name: String, countryCode: String)
    case weatherByCityID(id:Int)
    
    public var baseURL: URL {
        var url = URL(string: API.baseUrl)!
        url = url.appendingPathComponent(API.dataPath)
        url = url.appendingPathComponent(API.apiVersion)
        return url
    }
    
    public var path: String {
        return "forecast"
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        var params = [String: Any]()
        switch self {
        case .weatherByCityID(let id):
            params["id"] = id
        case .weatherByCityName(let name, let countryCode):
            params["q"] = "\(name),\(countryCode)"
        case .weatherByZipCode(zipCode: let zipCode):
            params["zip"] = zipCode
        case .weatherByLocation(let lat, let lon):
            params["lat"] = lat
            params["lon"] = lon
        }
        params["appid"] = API.apiKey
        params["units"] = API.units
        params["lang"] = Locale.current.languageCode
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var sampleData: Data {
        return Data()
    }
}
