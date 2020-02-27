//
//  CertainAlbumPhotosViewModel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/27/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import RxSwift
import VK_ios_sdk

class CertainAlbumPhotosViewModel {
    private let disposeBag = DisposeBag()
    private var albumPhotos = [VKCustomAlbumPhoto]()
    let albumID: Int
    init(albumID: Int) {
        self.albumID = albumID
    }
    func getPhotosInAlbum(albumID: Int, success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        guard let ownerID = CurrentUser.shared?.id else { return }
        getPhotosInAlbumApi(ownerID: ownerID, albumID: albumID)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let items = result.response?.items {
                    self.albumPhotos = items
                }
                success()
            }, onError: { error in
                failure(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func uploadImage(image: UIImage, success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        VKApiPhotos.init().getUploadServer(albumID)?.execute(resultBlock: { (response) in
            print(response?.json)
            success()
        }, errorBlock: { (error) in
            failure(error?.localizedDescription)
        })
    }
    
    func getPhoto(at row: Int) -> VKCustomAlbumPhoto {
        return albumPhotos[row]
    }
    
    func getNumberOfPhotos() -> Int {
        return albumPhotos.count
    }
}

private extension CertainAlbumPhotosViewModel {
    func getPhotosInAlbumApi(ownerID: Int, albumID: Int) -> Observable<VKCustomResult<[VKCustomAlbumPhoto]>> {
        return ApiClient.shared.request(VKCustomPhotosRouter.getPhotosInAlbum(ownerID.description, albumID.description))
    }
}
