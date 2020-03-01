//
//  GoodsInGroupsVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class GoodsInGroupsVC: UIViewController, Refreshable {
    private let viewModel: GoodsInGroupsViewModel
    
    struct Constants {
        static let margin = 12
        static let numberOfColumns = 2
        static let contentInset = 12
    }
    
    
    internal lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(fetchGoods), for: .valueChanged)
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
        view.register(GoodsInGroupCell.self, forCellWithReuseIdentifier: GoodsInGroupCell.identifier)
        
        view.refreshControl = refreshControl
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGoods()
        
        configUI()
    }
    
    init(groupID: Int, groupName: String?) {
        viewModel = GoodsInGroupsViewModel(groupID: groupID, groupName: groupName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UICollectionViewDelegate
extension GoodsInGroupsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsInGroupCell.identifier, for: indexPath) as! GoodsInGroupCell
        cell.setCell(good: viewModel.getGood(row: indexPath.row))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToCertainGoodVC(good: viewModel.getGood(row: indexPath.row))
    }
    
}

private extension GoodsInGroupsVC {
    //MARK: - Requests
    @objc func fetchGoods() {
        self.startRefreshing()
        viewModel.fetchGoods(success: { [weak self] in
            guard let self = self else { return }
            self.stopRefreshing()
            self.collectionView.reloadData()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.stopRefreshing()
            print(error)
        }
    }
    
    //MARK: - Methods
    func goToCertainGoodVC(good: GoodInGroup) {
        let vc = CertainGoodVC(good: good)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - ConfigUI
    func configUI() {
        setNavItem()
        
        view.addSubview(collectionView)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setNavItem() {
        if let groupName = viewModel.groupName {
            let label = UILabel()
            label.text = "Товары сообщества \(groupName)"
            navigationItem.titleView = label
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem()
    }
}
