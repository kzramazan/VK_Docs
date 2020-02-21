//
//  ContentSharingViewModel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/21/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk
import MobileCoreServices



struct ContentWallAttachment {
    var message: String?
    private var attachments: [ContentAttachmentType: Any]?
    
    init(message: String?, attachments: [ContentAttachmentType: Any]? ) {
        self.message = message
        self.attachments = attachments
    }
    
    func getAttachments() -> String? {
        guard let attachments = attachments, !attachments.isEmpty else { return nil }
        var result: String = ""
        attachments.forEach({ (key, value) in
            result.append("\(key)\(value)")
            
        })
        
        return result
    }
}
enum ContentWallParams: String, Hashable  {
    
    case message, attachments
}

enum ContentAttachmentType: String {
    case photo, audio, video, doc
    ///wiki-страница
    case page
    ///заметка
    case note
    ///Опрос
    case poll
    case album, audio_playlist
    ///Товар
    case market
    ///Маркет Товар
    case market_album
}

class ContentSharingViewModel {
    func publishContent(message: String, image: UIImage, success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        let vkImageParams = VKImageParameters()
        VKApi.uploadWallPhotoRequest(prepareImage(image: image)!, parameters: vkImageParams, userId: CurrentUser.shared!.id, groupId: 0)?.execute(resultBlock: { (response) in
            let photoInfo: VKPhoto = VKPhotoArray(array: response?.json as? [Any]).firstObject()
            
            let contentWall = ContentWallAttachment(message: message, attachments: [.photo: photoInfo.id.description])
            
            var params: Dictionary = Dictionary<ContentWallParams, Any>()
            params[.message] = contentWall.message
            if let attachments = contentWall.getAttachments() {
                params[.attachments] = attachments
            }
            
            VKApi.wall()?.post(params)?.execute(resultBlock: { (response) in
                
                success()
            }, errorBlock: { (error) in
                failure(error?.localizedDescription)
            })
        }, errorBlock: { (error) in
            failure(error.debugDescription)
        })
    }
    
    private func prepareImage(image: UIImage) -> UIImage? {
        let minValue = min(image.size.width, image.size.height)
        let croppedImage = image.crop(size: CGSize(width: minValue, height: minValue))
        let resizedImage = croppedImage.resize(newWidth: 300.0)
        return resizedImage
    }
    
}
