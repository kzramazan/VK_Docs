//
//  VKCustomAlbumPhoto.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/27/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

struct VKCustomAlbumPhoto: Codable, ImageChoosableUrl {
    let id: Int
    let sizes: [Images]?
    
    struct Images: Codable {
        let url: String
        ///Needed type: `r`
        let type: String
    }
}
