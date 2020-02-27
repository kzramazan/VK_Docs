//
//  Response.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/26/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

struct VKCustomResult<T: Codable>: Codable {
    let response: VKCustomResponse<T>?
}

struct VKCustomSingleResult<T: Codable>: Codable {
    let response: T?
}

struct VKCustomResponse<T: Codable>: Codable {
    let count: Int
    let items: T
}
