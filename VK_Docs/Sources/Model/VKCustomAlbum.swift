//
//  VKCustomAlbum.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/27/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

protocol ImageChoosableSrc {
    var sizes: [VKCustomAlbum.Images]? { get }
}

extension ImageChoosableSrc {
    func getImageUrl() -> String? {
        let image = sizes?.first { (images) -> Bool in
            images.type.lowercased() == "r"
        }
        
        
        return image?.src
    }
}

protocol ImageChoosableUrl {
    var sizes: [VKCustomAlbumPhoto.Images]? { get }
}

extension ImageChoosableUrl {
    func getImageUrl() -> String? {
        let image = sizes?.first { (images) -> Bool in
            images.type.lowercased() == "r"
        }
        
        return image?.url
    }
}

struct VKCustomAlbum: Codable, ImageChoosableSrc {
    let id: Int
    let thumbID: Int
    let ownerID: Int
    let title: String?
    let size: Int
    let sizes: [Images]?
    
    struct Images: Codable {
        let src: String
        ///Needed type: `r`
        let type: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, sizes, size
        case thumbID = "thumb_id"
        case ownerID = "owner_id"
    }
}
