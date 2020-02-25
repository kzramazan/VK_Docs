//
//  ApiRouter.swift
//  TestPillowz
//
//  Created by Казыбек Рамазан on 02/10/2019.
//  Copyright © 2019 Kazybek Ramazan. All rights reserved.
//

import Foundation

enum VKCustomGroups: ApiRequest {
    var identifier: String { return "groups" }
    
    case getMembers(String)
    
    var method: RequestType {
        switch self {
        case .getMembers:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getMembers:
            return "getMembers"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getMembers(let id):
            return ["filter": "friends", "group_id": id]
        }
    }
}
