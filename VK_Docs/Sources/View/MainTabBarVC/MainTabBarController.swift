//
//  MainTabBarController.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    private let defaultTabItem: () -> UITabBarItem = {
        let item = UITabBarItem()
        return item
    }
    
    private lazy var contentSharingVC: ContentSharingVC = {
        let vc = ContentSharingVC()
        vc.tabBarItem = {
            let item = defaultTabItem()
            item.image = Icon.contentSharing.getIcon
            item.title = "Публиковать"
            return item
        }()
        return vc
    }()
    
    private lazy var photoAlbumsVC: PhotoAlbumsVC = {
        let vc = PhotoAlbumsVC()
        vc.tabBarItem = {
            let item = defaultTabItem()
            item.image = Icon.photoAlbums.getIcon
            item.title = "Галерея"
            return item
        }()
        return vc
    }()
    
    private lazy var goodsVC: GoodsInCityVC = {
        let vc = GoodsInCityVC()
        vc.tabBarItem = {
            let item = defaultTabItem()
            item.image = Icon.goods.getIcon
            item.title = "Товары"
            return item
        }()
        return vc
    }()
    
    private lazy var groupUnsubscribe: GroupUnsubscribeVC = {
        let vc = GroupUnsubscribeVC()
        vc.tabBarItem = {
            let item = defaultTabItem()
            item.image = Icon.groups.getIcon
            item.title = "Сообщества"
            return item
        }()
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedMainTabBarController = self
        configureTabBar()
        configureVCs()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabels()
    }
}
//case goods
//case photoAlbums
//case contentSharing
//case settings

extension MainTabBarController: UITabBarControllerDelegate {
    
}

private extension MainTabBarController {
    private func updateLabels() {
        contentSharingVC.tabBarItem.title = "Публиковать"
        goodsVC.tabBarItem.title = "Товары"
        photoAlbumsVC.tabBarItem.title = "Галерея"
        groupUnsubscribe.tabBarItem.title = "Сообщества"
    }
    
    func configureVCs() {
        let vcs: [UIViewController] = [
            contentSharingVC,
            goodsVC,
            photoAlbumsVC,
            groupUnsubscribe
        ]
        
        self.viewControllers = vcs.map { vc in
            return UINavigationController(rootViewController: vc)
        }
    }
    
    private func configureTabBar() {
        self.delegate = self
        tabBar.tintColor = Tint.customButtonColor
        tabBar.barStyle = .default
        tabBar.barTintColor = .white
    }
}
