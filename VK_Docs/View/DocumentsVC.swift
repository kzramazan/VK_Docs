//
//  ViewController.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/16/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
class DocumentsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar()
        configUI()
    }
    
    private func setNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationController?.title = "Документы"
        self.navigationController?.navigationBar.isTranslucent = true
    }


}

private extension DocumentsVC {
    func configUI() {
        
    }
}

