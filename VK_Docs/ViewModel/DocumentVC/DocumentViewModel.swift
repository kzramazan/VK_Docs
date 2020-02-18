//
//  DocumentViewModel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import VK_ios_sdk

typealias SuccessCompletion = (() -> Void)
typealias ErrorCompletion = ((String?) -> Void)
class DocumentViewModel {
    private var vkDocsArr: VKDocsArray?
    func getDocumentList(success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        VKApiDocs.init().get()?.execute(resultBlock: { [weak self] (response) in
            guard let self = self else { return }
            if let json = (response?.json as? [AnyHashable : Any]), let arr = json["items"] as? [Any] {
                print(arr)
                self.vkDocsArr = VKDocsArray.init(array: arr)
            }
            success()
        }, errorBlock: { (error) in
            failure(error?.localizedDescription)
        })
    }
    
    func getNumOfRows() -> Int {
        return Int(vkDocsArr?.count ?? 0)
    }
    
    func getList() -> VKDocsArray? {
        return vkDocsArr
    }
}
