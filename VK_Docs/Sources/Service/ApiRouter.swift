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
    case getAddresses(String)
    ///CityID
    case searchShops(String)
    
    var method: RequestType {
        switch self {
        case .getMembers, .getAddresses, .searchShops:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getMembers:
            return "getMembers"
        case .getAddresses:
            return "getAddresses"
        case .searchShops:
            return "search"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getMembers(let id):
            return ["filter": "friends", "group_id": id]
        case .getAddresses(let id):
            return ["group_id": id]
        case .searchShops(let cityID):
            return ["q":" ", "type": "groups", "city_id": cityID, "market": "1", "sort": "2"]
        }
    }
}

enum VKCustomPhotosRouter: ApiRequest {
    var identifier: String { return "photos" }
    
    ///ownerID
    case getAlbums(String)
    ///ownerID, albumID
    case getPhotosInAlbum(String, String)
    ///albumID, title
    case editAlbum(String, String)
    ///albumID
    case deleteAlbum(String)
    ///title
    case createAlbum(String)
    
    var method: RequestType {
        switch self {
        case .getAlbums, .getPhotosInAlbum:
            return .GET
        case .editAlbum, .createAlbum:
            return .POST
        case .deleteAlbum:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .getAlbums:
            return "getAlbums"
        case .getPhotosInAlbum:
            return "get"
        case .editAlbum:
            return "editAlbum"
        case .deleteAlbum:
            return "deleteAlbum"
        case .createAlbum:
            return "createAlbum"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getAlbums(let ownerID):
            return ["need_system": true.description, "need_covers": true.description, "photo_sizes": true.description, "owner_id": ownerID]
        case .getPhotosInAlbum(let ownerID, let albumID):
            return ["album_id": albumID, "photo_sizes": true.description, "owner_id": ownerID]
        case .editAlbum(let albumID, let title):
            return ["title": title, "album_id": albumID]
        case .deleteAlbum(let albumID):
            return ["album_id": albumID]
        case .createAlbum(let title):
            return ["title": title]
        }
    }
}

enum VKCustomDatabaseRouter: ApiRequest {
    var identifier: String { return "database" }
    
    case getCities
    
    var method: RequestType {
        switch self {
        case .getCities:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .getCities:
            return "getCities"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .getCities:
            return ["country_id": "1", "count": "100"]
        }
    }
}


enum VKCustomMarketRouter: ApiRequest {
    var identifier: String { return "market" }
    
    ///Возвращает список товаров в сообществе.
    case get(String)
    ///owner_id, good_id
    case getById(String, String)
    
    var method: RequestType {
        switch self {
        case .get, .getById:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .get:
            return "get"
        case .getById:
            return "getById"
        }
    }
    
    var parameters: [String : String] {
        switch self {
        case .get(let id):
            return ["country_id": "RU", "need_all": "1", "owner_id": "-\(id)"]
        case .getById(let ownerID, let goodID):
            return ["item_ids": "-\(ownerID)_\(goodID)"]
        }
    }
}
