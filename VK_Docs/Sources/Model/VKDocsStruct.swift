//
//  VKDocsStruct.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import VK_ios_sdk

struct VKDocsStruct {
    private var vkDoc: VKDocs
    enum VKDocsExt: Int {
        case txt = 1
        case archive = 2
        case gif = 3
        case image = 4
        case audio = 5
        case video = 6
        case ebook = 7
        case other = 8
    }
    
    init(vkDoc: VKDocs) {
        self.vkDoc = vkDoc
    }
    
    var getImage: UIImage? {
        get {
            switch VKDocsExt(rawValue: vkDoc.type as! Int) {
            case .txt:
                return UIImage(named: "text_docs")
            case .archive:
                return UIImage(named: "zip_docs")
            case .gif:
                return UIImage(named: vkDoc.photo_100)
            case .audio:
                return UIImage(named: "audio_docs")
            case .video:
                return UIImage(named: "video_docs")
            case .ebook:
                return UIImage(named: "book_docs")
            default:
                return UIImage(named: "other_docs")
            }
        }
    }
}
