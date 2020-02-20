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
        case archive
        case gif
        case image
        case audio
        case video
        case ebook
        case other
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
            case .gif, .image:
                return nil
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
