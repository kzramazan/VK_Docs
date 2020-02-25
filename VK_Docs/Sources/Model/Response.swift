//
//  Response.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/26/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

struct VKCustomResult<T: Codable>: Codable {
    let response: T?
}

struct VKMembersResponse: Codable {
    let count: Int
}
