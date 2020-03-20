//
//  QuickLookImageVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/28/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class QuickLookImageVC: UIViewController {
    private var imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sharedMainTabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sharedMainTabBarController?.tabBar.isHidden = false
    }
    
    func loadImage(urlPath: String) {
        imageView.loadImageFromUrl(urlString: urlPath)
    }
}

private extension QuickLookImageVC {
    func configUI() {
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        imageView.backgroundColor = .clear
        makeConstraints()
    }
    
    func makeConstraints() {
        imageView.snp.makeConstraints { (m) in
            m.right.left.equalToSuperview()
            m.centerY.equalToSuperview()
            m.height.greaterThanOrEqualTo(0).priority(.high)
        }
    }
}
