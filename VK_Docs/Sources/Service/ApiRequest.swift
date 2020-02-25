//
//  ApiRequest.swift
//  TestPillowz
//
//  Created by Казыбек Рамазан on 02/10/2019.
//  Copyright © 2019 Kazybek Ramazan. All rights reserved.
//

import Foundation
public enum RequestType: String {
    case GET, POST, DELETE, PATCH
}
protocol ApiRequest {
    var identifier: String { get }
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String: String] { get }
}

extension ApiRequest {
    func asURLRequest() -> URLRequest {
        let baseUrl = URL(string: Constants.baseURL)!.appendingPathComponent("\(identifier).\(path)")
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { fatalError("Couldn't create url components") }
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1)
        }
        
        if let ticket = Session.shared.ticket {
            components.queryItems?.append(URLQueryItem(name: "access_token", value: ticket))
        }
        
        components.queryItems?.append(URLQueryItem(name: Constants.SDKVersionKey, value: Constants.SDKVersion.description))
        guard let url = components.url else { fatalError("Couldn't get url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
}
