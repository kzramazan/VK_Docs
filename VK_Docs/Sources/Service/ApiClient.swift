//
//  ApiClient.swift
//  TestPillowz
//
//  Created by Казыбек Рамазан on 02/10/2019.
//  Copyright © 2019 Kazybek Ramazan. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


class ApiClient {
    static let shared = ApiClient()
    func request<T: Codable>(_ apiRouter: ApiRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRouter.asURLRequest()
            Alamofire.request(request)
                .validate()
                .responseJSON { response in
                    print(response.description)
                    if response.description.range(of: "-1009") != nil {
                        print("No internet connection")
                        
                        observer.onError(ServiceError.noInternetConnection)
                        return
                    }
                    print("Request: ", request)
                    print("Request Type: ", apiRouter.method)
                    print("Status Code: ", response.response?.statusCode as Any)
                    print("---------------------------")
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? ServiceError.notFound)
                            return
                        }
                        do {
                            let model: T = try JSONDecoder().decode(T.self, from: data)
    
                            observer.onNext(model)

                        } catch let error {

                            observer.onError(error)
                        }

                    case .failure(let error):
                        if let statusCode = response.response?.statusCode {
                            if let reason = ServiceError(rawValue: statusCode) {
                                observer.onError(reason)
                            }
                            observer.onError(error)
                        }else {
                        observer.onError(ServiceError.noInternetConnection)
                    }
                }
            }
            return Disposables.create()
        }
    }
}
