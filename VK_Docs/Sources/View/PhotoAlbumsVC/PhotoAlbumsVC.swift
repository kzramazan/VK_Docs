//
//  PhotoAlbumsVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/26/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class PhotoAlbumsVC: UIViewController, Refreshable {
    private let viewModel = PhotoAlbumsViewModel()
    
    private var longPressEnabled: Bool = false
    private var isDoneBtnHidden: Bool = true {
        didSet {
            if isDoneBtnHidden {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(changeAlbumTapped))
                navigationItem.leftBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "add_outline"), style: .plain, target: self, action: #selector(addNewAlbumTapped))
            }else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(doneBtnTapped))
                navigationItem.leftBarButtonItem =  nil
            }
            
            longPressEnabled = !isDoneBtnHidden
            collectionView.reloadData()
        }
    }
    struct Constants {
        static let margin = 12
        static let numberOfColumns = 2
        static let contentInset = 12
    }
    
    
    internal lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(getAlbums), for: .valueChanged)
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (Int(view.frame.width) / Constants.numberOfColumns - 68/3)
        layout.itemSize = CGSize(width: width, height: width + 68)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.headerReferenceSize = CGSize(width: 0, height: 10)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.register(PhotoAlbumCollectionViewCell.self, forCellWithReuseIdentifier: PhotoAlbumCollectionViewCell.identifier)
        
        view.refreshControl = refreshControl
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAlbums()
        
        configUI()
    }
}

//MARK: - UICollectionViewDelegate
extension PhotoAlbumsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfAlbums()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoAlbumCollectionViewCell.identifier, for: indexPath) as! PhotoAlbumCollectionViewCell
        cell.delegate = self
        cell.setCell(album: viewModel.getAlbum(at: indexPath.row))
        if longPressEnabled {
            cell.startAnimate()
        }else {
            cell.stopAnimate()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToCertainAlbumVC(with: viewModel.getAlbum(at: indexPath.row).id)
    }
}

extension PhotoAlbumsVC: PhotoAlbumCollectionViewCellDelegate {
    func removeBtnTapped(album: VKCustomAlbum) {
        deleteAlbumTapped(album: album)
    }
}

private extension PhotoAlbumsVC {
    //MARK: - Requests
    @objc func getAlbums() {
        self.startRefreshing()
        viewModel.getAlbums(success: { [weak self] in
            guard let self = self else { return }
            self.stopRefreshing()
            self.collectionView.reloadData()
        }) { [weak self] (error) in
            self?.stopRefreshing()
        }
    }
    //MARK: - Methods
    func goToCertainAlbumVC(with id: Int) {
        let vc = CertainAlbumPhotosVC(albumID: id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Actions
    @objc func doneBtnTapped() {
        isDoneBtnHidden = true
    }
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        collectionView.reloadData()
        isDoneBtnHidden = false
    }
    
    @objc func addNewAlbumTapped() {
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Введите название нового альбома"
        }
        let saveAction = UIAlertAction(title: "Создать", style: UIAlertAction.Style.default, handler: { [weak self] alert -> Void in
            guard let self = self else { return }
            let textField = alertController.textFields![0] as UITextField
            if let title = textField.text {
                self.createAlbum(title: title)
            }
        })
        let cancelAction = UIAlertAction(title: "Отменить", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func createAlbum(title: String) {
        viewModel.createAlbum(title: title, success: { [weak self] (album) in
            guard let self = self, let album = album else { return }
            self.viewModel.addAlbum(album: album)
            self.collectionView.insertItems(at: [IndexPath(row: self.viewModel.getNumberOfAlbums() - 1, section: 0)])
        }) { (error) in
            print(error)
        }
    }
    
    func deleteAlbumTapped(album: VKCustomAlbum) {
        viewModel.deleteAlbum(album: album, success: { [weak self] row in
            guard let self = self else { return }
            self.collectionView.deleteItems(at: [IndexPath(row: row, section: 0)])
        }) { (error) in
            print(error)
        }
    }
    
    @objc func changeAlbumTapped() {
        isDoneBtnHidden = false
    }
    
    
    
    //MARK: - ConfigUI
    func configUI() {
        view.addSubview(collectionView)
        navigationItem.title = "Альбомы"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add_outline"), style: .plain, target: self, action: #selector(addNewAlbumTapped))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .plain, target: self, action: #selector(changeAlbumTapped))
        
        makeConstraints()
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
