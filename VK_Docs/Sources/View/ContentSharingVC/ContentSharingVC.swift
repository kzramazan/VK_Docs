//
//  ContentSharingVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class ContentSharingVC: UIViewController {
    private lazy var placeholderView: ListPlaceholderView = {
        let view = ListPlaceholderView(frame: self.view.frame,
            image: UIImage(named: ""),
            title: "Делитесь фотографиями",
            subtitle: "Поделитесь фотографией на стене, и добавьте к ней описание",
            btnName: "Выбрать фото")
        
        view.delegate = self
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }



}



private extension ContentSharingVC {
    //MARK: - Methods
    
    
    //MARK: - Actions
//    func
    
    //MARK: - ConfigUI
    func configUI() {
        view.backgroundColor = .white
        view.addSubview(placeholderView)
    }
    
}

//MARK: - ListPlaceholderViewDelegate
extension ContentSharingVC: ListPlaceholderViewDelegate {
    func didTapPlaceholderSubmitBtn(_ sender: UIButton) {
        goToImagePicker
    }
    
    
}
