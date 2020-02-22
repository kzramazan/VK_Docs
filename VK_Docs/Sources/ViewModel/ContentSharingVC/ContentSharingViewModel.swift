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
    var VK_API_MESSAGE: String?
    var VK_API_ATTACHMENTS: String?
    
    init(message: String?, attachments: String? ) {
        self.VK_API_MESSAGE = message
        self.VK_API_ATTACHMENTS = attachments
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
        
        VKApi.uploadWallPhotoRequest(image, parameters: vkImageParams, userId: CurrentUser.shared!.id, groupId: 0)?.execute(resultBlock: { (response) in
            guard let dict = response?.json as? [Any], dict.count > 0, let photoArr = VKPhotoArray(array: dict) else { return failure(nil)}
            let vkPhoto = VKPhoto(dictionary: photoArr.firstObject()!.fields)
            
            
            guard vkPhoto?.photo_130 != nil, let attachmentPhoto = vkPhoto?.attachmentString else { return failure(nil)}
            
            
            let contentWall = ContentWallAttachment(message: message, attachments: attachmentPhoto)

            var params: Dictionary = Dictionary<AnyHashable, Any>()

            params[VK_API_MESSAGE] = contentWall.VK_API_MESSAGE
            params[VK_API_ATTACHMENTS] = contentWall.VK_API_ATTACHMENTS
            
            VKApi.wall()?.post(params)?.execute(resultBlock: { (response) in

                success()
            }, errorBlock: { (error) in
                failure(error?.localizedDescription)
            })
        }, errorBlock: { (error) in
            failure(error.debugDescription)
        })
    }
}
