//
//  Constants.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/17/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

struct Constants {
    static let sharedProfile = "SharedUserProfile"
    static let vkAppID = "7323303"
    enum VKPermission {
        typealias RawValue = String
        case friends, email, docs
    }
    
    
}
