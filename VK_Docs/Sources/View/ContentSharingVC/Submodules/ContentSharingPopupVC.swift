//
//  ContentSharingPopupVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/20/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import FloatingPanel

protocol ContentToPublishDelegate where Self: UIViewController {
    func contentToPublish(title: String, image: UIImage, toDismiss: UIViewController?)
}

class ContentSharingPopupVC: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var sharingImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var delegate: ContentToPublishDelegate?
    
    var imageForSubmit: UIImage? {
        didSet {
            self.sharingImageView.image = imageForSubmit
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }


}

private extension ContentSharingPopupVC {
    //MARK: - Actions
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let image = imageForSubmit else { return }
        
        delegate?.contentToPublish(title: commentTextView.text, image: image, toDismiss: self)
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - ConfigUI
    func configUI() {
        submitButton.backgroundColor = Tint.customButtonColor
        submitButton.layer.cornerRadius = 10
        submitButton.setTitleColor(.white, for: .normal)
        
        commentTextView.layer.cornerRadius = commentTextView.frame.width / 22
        commentTextView.showsVerticalScrollIndicator = false
        commentTextView.backgroundColor = Tint.textViewBackgroundColor
        commentTextView.isScrollEnabled = true
        commentTextView.textContainerInset = UIEdgeInsets(top: 7.5, left: 5, bottom: 8.5, right: 5);
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.delegate = self
        submitButton.setTitle("Отправить", for: .normal)
    }
}

//MARK: - FloatingPanelControllerDelegate
extension ContentSharingPopupVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingContentSharingPanelLayout()
    }
}

extension ContentSharingPopupVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let numLines = Int((textView.contentSize.height / (textView.font?.lineHeight ?? 1)))
        if numLines > 5 {
            commentTextView.snp.updateConstraints { (make) in
                make.height.equalTo(5 * textView.font!.lineHeight + 20)
            }
        }else {
            commentTextView.snp.updateConstraints { (make) in
                make.height.equalTo((CGFloat(numLines) * textView.font!.lineHeight) + 20)
            }
        }
    }
    
}


