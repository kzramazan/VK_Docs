//
//  ContentSharingVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import FloatingPanel


class ContentSharingVC: UIViewController, BaseViewControllerProtocol {
    private let viewModel = ContentSharingViewModel()
    
    private lazy var camera: Camera = {
        let camera = Camera(delegate_: self)
        return camera
    }()
    
    private lazy var placeholderView: ListPlaceholderView = {
        let view = ListPlaceholderView(frame: self.view.frame,
            image: UIImage(named: "share_outline"),
            title: "Делитесь фотографиями",
            subtitle: "Поделитесь фотографией на стене, и добавьте к ней описание",
            btnName: "Выбрать фото")
        
        view.delegate = self
        view.imageSize = CGSize(width: 52, height: 40)
        view.imageTintColor = UIColor(hex: "#99A2AD")
        
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

}



private extension ContentSharingVC {
    //MARK: - Requests
    func publishContent(message: String, image: UIImage, _ toDismiss: UIViewController? = nil) {
        self.showActivityIndicator()
        viewModel.publishContent(message: message, image: image, success: { [weak self] in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            self.showSuccess(message: "Запись успешно опубликована")
            
            if toDismiss != nil {
                toDismiss?.dismiss(animated: true)
            }
        }) { [weak self] (error) in
            guard let self = self else { return }
            
            self.hideActivityIndicator()
            self.showError(message: error)
        }
    }
    
    //MARK: - Methods
    
    
    //MARK: - Actions
    func goToImagePicker() {
        self.camera.PresentPhotoLibrary(target: self, canEdit: true)
    }
    
    //MARK: - ConfigUI
    func configUI() {
        view.backgroundColor = .white
        view.addSubview(placeholderView)
        
        
        makeConstraints()
    }
    
    func makeConstraints() {
        placeholderView.snp.makeConstraints { ( make) in
            make.centerY.centerX.equalToSuperview()
            
        }
    }
    
}


//MARK: - ListPlaceholderViewDelegate
extension ContentSharingVC: ListPlaceholderViewDelegate {
    func didTapPlaceholderSubmitBtn(_ sender: UIButton) {
        goToImagePicker()
    }
    
    
}



//MARK: - UIImage
extension ContentSharingVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        let image = info[.editedImage] as? UIImage
        
        let contentSharingPopupVC: FloatingPanelController = {
            let vc = ContentSharingPopupVC()
            let fvc = FloatingPanelController()
            fvc.contentMode = .fitToBounds
            fvc.configure(delegate: vc, vc: vc)
            vc.imageForSubmit = image
            vc.delegate = self
            return fvc
        }()
        
        self.present(contentSharingPopupVC, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

extension ContentSharingVC: ContentToPublishDelegate {
    func contentToPublish(title: String, image: UIImage, toDismiss: UIViewController?) {
        publishContent(message: title, image: image, toDismiss)
    }
    
    
}
