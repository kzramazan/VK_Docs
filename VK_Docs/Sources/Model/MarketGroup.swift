//
//  MarketGroups.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation
struct MarketGroup: Codable {
    let id: Int
    let name: String?
    let isClosed: Int
    let photo100: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case isClosed = "is_closed"
        case photo100 = "photo_100"
    }
}
