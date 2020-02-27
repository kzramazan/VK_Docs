//
//  PhotoAlbumsViewModel.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/26/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import RxSwift
import VK_ios_sdk

class PhotoAlbumsViewModel {
    let disposeBag = DisposeBag()
    private var albums = [VKCustomAlbum]()
    
    func getAlbums(success: @escaping SuccessCompletion, failure: @escaping ErrorCompletion) {
        guard let ownerID = CurrentUser.shared?.id else { return }
        getAlbumApi(ownerID: ownerID)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let albums = result.response?.items {
                    self.albums = albums
                }
                success()
            }, onError: { error in
                failure(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func createAlbum(title: String, success: @escaping (VKCustomAlbum?) -> Void, failure: @escaping ErrorCompletion) {
        createAlbumApi(title: title)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                success(result.response)
            }, onError: { error in
                failure(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func deleteAlbum(album: VKCustomAlbum, success: @escaping (Int) -> Void, failure: @escaping ErrorCompletion) {
        deleteAlbumApi(albumID: album.id)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                guard let status = result.response, status == 1 else {
                    failure("Не смогли удалить альбом")
                    return
                }
                if let row = self.albums.firstIndex(where: { (currentAlbum) -> Bool in
                    currentAlbum.id == album.id
                }) {
                    self.albums.remove(at: row)
                    success(row)
                }
            }, onError: { error in
                failure(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func getNumberOfAlbums() -> Int {
        return albums.count
    }
    
    func getAlbum(at row: Int) -> VKCustomAlbum {
        return albums[row]
    }
    
    func addAlbum(album: VKCustomAlbum) {
        albums.append(album)
    }
}

private extension PhotoAlbumsViewModel {
    func getAlbumApi(ownerID: Int) -> Observable<VKCustomResult<[VKCustomAlbum]>> {
        return ApiClient.shared.request(VKCustomPhotosRouter.getAlbums(ownerID.description))
    }
    
    func createAlbumApi(title: String) -> Observable<VKCustomSingleResult<VKCustomAlbum>> {
        return ApiClient.shared.request(VKCustomPhotosRouter.createAlbum(title))
    }
    
    func deleteAlbumApi(albumID: Int) -> Observable<VKCustomSingleResult<Int>> {
        return ApiClient.shared.request(VKCustomPhotosRouter.deleteAlbum(albumID.description))
    }
}
