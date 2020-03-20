//
//  CertainAlbumPhotosVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/27/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class CertainAlbumPhotosVC: UIViewController, Refreshable {
    private let viewModel: CertainAlbumPhotosViewModel
    
    struct Constants {
        static let margin = 0
        static let numberOfColumns = 3
        static let contentInset = 2
    }
    
    private lazy var camera: Camera = {
        let camera = Camera(delegate_: self)
        return camera
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (Int(view.frame.width) / Constants.numberOfColumns - 2)
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        layout.headerReferenceSize = CGSize(width: 0, height: 10)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CertainAlbumPhotosCollectionViewCell.self, forCellWithReuseIdentifier: CertainAlbumPhotosCollectionViewCell.identifier)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = .zero
        
        view.refreshControl = refreshControl
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    internal lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(getAlbumPhotos), for: .valueChanged)
        return control
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbumPhotos()
        configUI()
    }
    
    init(albumID: Int) {
        viewModel = CertainAlbumPhotosViewModel(albumID: albumID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UICollectionViewDelegate
extension CertainAlbumPhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CertainAlbumPhotosCollectionViewCell.identifier, for: indexPath) as! CertainAlbumPhotosCollectionViewCell
        cell.setCell(albumPhoto: viewModel.getPhoto(at: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let imageStr = viewModel.getPhoto(at: indexPath.row).getImageUrl() {
            let vc = QuickLookImageVC()
            vc.loadImage(urlPath: imageStr)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

//MARK: - UIImagePickerControllerDelegate
extension CertainAlbumPhotosVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage {
            viewModel.uploadImage(image: image, success: { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }) { (error) in
                print("Error here: ", error as Any)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

private extension CertainAlbumPhotosVC {
    //MARK: - Requests
    @objc func getAlbumPhotos() {
        startRefreshing()
        
        viewModel.getPhotosInAlbum(albumID: viewModel.albumID, success: { [weak self] in
            guard let self = self else { return }
            self.stopRefreshing()
            self.collectionView.reloadData()
        }) { [weak self] (error) in
            self?.stopRefreshing()
        }
    }
    
    //MARK: - Actions
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addPhotoToAlbumTapped() {
        camera.PresentPhotoLibrary(target: self, canEdit: true)
    }
    
    //MARK: - ConfigUI
    func configUI() {
        view.backgroundColor = .white
        navigationItem.title = "Альбомы"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "chevron_left"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add_outline"), style: .plain, target: self, action: #selector(addPhotoToAlbumTapped))
        view.addSubview(collectionView)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
