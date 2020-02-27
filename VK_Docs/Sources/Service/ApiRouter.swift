//
//  ApiRouter.swift
//  TestPillowz
//
//  Created by Казыбек Рамазан on 02/10/2019.
//  Copyright © 2019 Kazybek Ramazan. All rights reserved.
//

import Foundation

enum VKCustomGroupsRouter: ApiRequest {
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

enum VKCustomPhotosRouter: ApiRequest {
    var identifier: String { return "photos" }
    
    case getAlbums(String)
    case getPhotosInAlbum(String, String)
    
    var method: RequestType {
        switch self {
        case .getAlbums, .getPhotosInAlbum:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getAlbums, .getPhotosInAlbum:
            return "getAlbums"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getAlbums(let ownerID):
            return ["need_system": true.description, "owner_id": ownerID]
        case .getPhotosInAlbum(let ownerID
            ):
            return ["need_system": true.description, "owner_id": ownerID]
        }
    }
}



