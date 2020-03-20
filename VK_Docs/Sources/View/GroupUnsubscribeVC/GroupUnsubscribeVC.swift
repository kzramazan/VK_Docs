//
//  GroupUnsubscribeVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/22/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk
import FloatingPanel

class GroupUnsubscribeVC: UIViewController, Refreshable {
    struct Constants {
        static let margin = 12
        static let numberOfColumns = 3
        static let contentInset = 12
    }

    private let viewModel = GroupUnsubscribeViewModel()
    private let bottomView = UIView()

    internal lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(getGroupList), for: .valueChanged)
        return control
    }()

    private lazy var unsubscribeButtonView: CustomCountableButtonView = {
        let button = CustomCountableButtonView()
        button.backgroundColor = Tint.customButtonColor
        button.titleText = "Отписаться"
        button.counter = 0
        button.clipsToBounds = true

        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (Int(view.frame.width) / 3) - Constants.contentInset
        let height = width + 52
        layout.itemSize = CGSize(width: width, height: height)
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
        view.register(GroupUnsubscribeCollectionViewCell.self, forCellWithReuseIdentifier: GroupUnsubscribeCollectionViewCell.identifier)
        view.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: CollectionViewHeaderView.self))

        view.refreshControl = refreshControl
        view.delegate = self
        view.dataSource = self

        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        bindViewModel()
        getGroupList()
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
    }

    private func setNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let label = UILabel()
        label.font = UIFont(name: "Arial-BoldMT", size: 17)
        navigationController?.navigationBar.backgroundColor = .white
        label.text = "Сообщества"
        self.navigationItem.titleView = label
        self.navigationController?.navigationBar.isTranslucent = true
    }


}


extension GroupUnsubscribeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of: ", viewModel.getNumberOfGroups())
        return viewModel.getNumberOfGroups()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupUnsubscribeCollectionViewCell.identifier, for: indexPath) as! GroupUnsubscribeCollectionViewCell
        cell.isCellSelected = viewModel.groupIsSelected(row: indexPath.row)
        cell.setVKGroup(vkGroup: viewModel.getGroupVK(row: indexPath.row))

        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(lpgr)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupUnsubscribeCollectionViewCell.identifier, for: indexPath) as! GroupUnsubscribeCollectionViewCell
        viewModel.handleGroupSelection(row: indexPath.row)
        cell.isCellSelected = viewModel.groupIsSelected(row: indexPath.row)

        collectionView.reloadItems(at: [indexPath])

    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CollectionViewHeaderView.self), for: indexPath) as! CollectionViewHeaderView
        cell.titleStr = "Отписаться от сообществ"
        cell.descriptionStr = "Коснитесь и удерживайте, чтобы увидеть информацию о сообществе"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
}

private extension GroupUnsubscribeVC {
    //MARK: - Methods
    func bindViewModel() {
        viewModel.groupSelectionCompletion = { [weak self] in
            guard let self = self else { return }
            self.unsubscribeButtonView.counter = self.viewModel.getNumberOfGroupsSelected()
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let self = self else { return }
                self.bottomView.alpha = self.viewModel.getNumberOfGroupsSelected() == 0 ? 0 : 1
            })
        }
    }

    func showDetailedGroupInfo(vkGroup: VKGroup) {
        viewModel.getNumberOfFriends(groupID: Int(truncating: vkGroup.id), success: { [weak self] (counter) in
            guard let self = self else { return }
            self.showPopupGroupInfo(vkGroup: vkGroup, friends: counter)
        }, failure: { [weak self] error in
            guard let self = self else { return }
            self.showPopupGroupInfo(vkGroup: vkGroup, friends: nil)
        })
    }

    func showPopupGroupInfo(vkGroup: VKGroup, friends: Int?) {
        let groupInfoPopupVC: FloatingPanelController = {
            let vc = GroupInfoPopupVC(vkGroup: vkGroup)
            vc.friends = friends
            let fvc = FloatingPanelController()
            fvc.contentMode = .fitToBounds
            fvc.configure(delegate: vc, vc: vc)
            return fvc
        }()

        self.present(groupInfoPopupVC, animated: true)
    }

    func configCollectionView() {}


    //MARK: - Requests



    //MARK: - Requests
    @objc func getGroupList() {
        self.startRefreshing()
        viewModel.fetchGroupList(success: { [weak self] in
            guard let self = self else { return }
            self.stopRefreshing()
            self.collectionView.reloadData()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.stopRefreshing()
            print(error)
        }
    }

    //MARK: - ConfigUI
    func configUI() {
        configCollectionView()
        view.backgroundColor = .white
        bottomView.addBackgroundBlur(style: .extraLight)
        bottomView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        bottomView.alpha = 0

        view.addSubview(collectionView)
        view.addSubview(bottomView)

        bottomView.addSubview(unsubscribeButtonView)
        bottomView.bringSubviewToFront(unsubscribeButtonView)

        makeConstraints()
        self.view.setNeedsDisplay()
        view.layoutIfNeeded()

        unsubscribeButtonView.layer.cornerRadius = unsubscribeButtonView.frame.width / 35
        unsubscribeButtonView.configUI()
    }

    func makeConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-50)
            make.right.left.equalToSuperview()
            make.height.equalTo(102)
        }

        unsubscribeButtonView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(44)
        }
    }


}

//MARK: - UILongGestureRecognizerDelegate
extension GroupUnsubscribeVC: UIGestureRecognizerDelegate {
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != UIGestureRecognizer.State.began){
            return
        }

        let p = gestureRecognizer.location(in: collectionView)

        if let indexPath: IndexPath = self.collectionView.indexPathForItem(at: p) {
            showDetailedGroupInfo(vkGroup: viewModel.getGroupVK(row: indexPath.row))
        }
    }
}
