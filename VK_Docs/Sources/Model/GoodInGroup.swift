//
//  GoodInGroup.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

public struct GoodInGroup: Codable {
    let id: Int
    let title: String?
    let ownerID: Int
    let thumbPhoto: String?
    let price: Price
    let description: String?
    
    struct Price: Codable {
        let text: String?
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, description
        case ownerID = "owner_id"
        case thumbPhoto = "thumb_photo"
    }
}
