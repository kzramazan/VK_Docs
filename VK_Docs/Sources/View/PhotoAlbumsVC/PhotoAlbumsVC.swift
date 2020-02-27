//
//  PhotoAlbumsVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/26/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class PhotoAlbumsVC: UIViewController, Refreshable {
    struct Constants {
        static let margin = 12
        static let numberOfColumns = 2
        static let contentInset = 12
    }
    
    
    internal lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
//        control.addTarget(self, action: #selector(getGroupList), for: .valueChanged)
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (Int(view.frame.width) / Constants.numberOfColumns) - Constants.contentInset
        layout.itemSize = CGSize(width: width, height: width + 68)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        
        layout.sectionHeadersPinToVisibleBounds = false
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 150)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.register(PhotoAlbumCollectionViewCell.self, forCellWithReuseIdentifier: PhotoAlbumCollectionViewCell.identifier)
        
        view.refreshControl = refreshControl
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    


}

extension PhotoAlbumsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
