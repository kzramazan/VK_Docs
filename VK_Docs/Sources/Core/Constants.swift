//
//  Constants.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

struct Constants {
    static let baseURL = "https://api.vk.com/method/"
    
    static let SDKVersion = 5.103
    static let SDKVersionKey = "v"
    
    static let sharedProfile = "SharedUserProfile"
    static let vkAppID = "7323303"
    static let tokenKey = "TOKEN_KEY"
    
}

enum ContentType: String {
    case json = "application/json; charset=utf-8"
}
