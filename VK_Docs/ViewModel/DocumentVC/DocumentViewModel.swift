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
                self.vkDocsArr = VKDocsArray.init(array: arr)
            }
            
            success()
        }, errorBlock: { (error) in
            failure(error?.localizedDescription)
        })
    }
    
    func deleteDocument(docID: Int, at row: Int, success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        guard let currUser = CurrentUser.shared else { return }
        
        VKApiDocs.init().delete(currUser.id, andDocID: docID)?.execute(resultBlock: { [weak self] (response) in
            guard let self = self  else { return }
            self.deleteDocument(at: row)

            success()
        }, errorBlock: { (error) in
            failure(error?.localizedDescription)
        })
    }
    
    func editDocument(docID: Int, title: String, at row: Int, success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        VKApiDocs.init().edit(docID, title: title)?.execute(resultBlock: { (response) in
            self.changeDocumentTitle(at: row, title: title)
            
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

private extension DocumentViewModel {
    func changeDocumentTitle(at row: Int, title: String) {
        guard let vkDocsArr = vkDocsArr else { return }
        
        vkDocsArr[UInt(row)].title = title
    }
    
    func deleteDocument(at row: Int) {
        guard let vkDocsArr = vkDocsArr else { return }
        
        vkDocsArr.remove(vkDocsArr[UInt(row)])
    }
}
