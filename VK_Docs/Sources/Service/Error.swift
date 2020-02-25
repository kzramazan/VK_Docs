//
//  Error.swift
//  TestPillowz
//
//  Created by Казыбек Рамазан on 02/10/2019.
//  Copyright © 2019 Kazybek Ramazan. All rights reserved.
//

import Foundation

enum ServiceError: Int, Error {
    case unauthorized = 401
    case notFound = 404
    case noInternetConnection = 1009
}
