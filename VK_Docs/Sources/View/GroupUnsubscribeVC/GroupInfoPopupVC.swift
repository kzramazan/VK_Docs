//
//  GroupInfoPopupVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/22/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk
import FloatingPanel

class GroupInfoPopupVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!

    @IBOutlet weak var descriptionImageView: UIImageView!
    private let vkGroup: VKGroup

    var friends: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }

    init(vkGroup: VKGroup) {
        self.vkGroup = vkGroup
        super.init(nibName: nil, bundle: nil)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension GroupInfoPopupVC {
    //MARK: - Actions
    @IBAction func exitBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func openBtnTapped(_ sender: UIButton) {
        exitBtnTapped(sender)
    }

    //MARK: - ConfigUI
    func configUI() {
        view.roundCorners(corners: [.topLeft, .topRight], radius: view.frame.width / 26.7)

        titleLabel.font = UIFont(name: "Arial-BoldMT", size: 17)

        openButton.backgroundColor = Tint.customButtonColor
        openButton.layer.cornerRadius = openButton.frame.width / 35
        titleLabel.text = vkGroup.name ?? "Без названия"
        followersLabel.text = "\(Int(truncating: vkGroup.members_count ?? 0).roundedWithAbbreviations) подписчиков"
        if let friends = friends, friends > 0 {
            followersLabel.text = "\(followersLabel.text!) · \(friends) друзей "
        }

        descriptionLabel.text = vkGroup.description
        descriptionImageView.isHidden = (vkGroup.description == nil) || (vkGroup.description.isEmpty)

        openButton.setTitle("Открыть", for: .normal)
        openButton.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 17)
        openButton.setTitleColor(.white, for: .normal)

        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }

    private func getContentHeight() -> CGFloat {
        print(view.frame.maxY)
        return openButton.frame.maxY + 46 * 2
    }
}



//MARK: - FloatingPanelControllerDelegate
extension GroupInfoPopupVC: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        let layout = CustomFloatingGroupInfoPanelLayout()
        layout.contentHeight = getContentHeight()
        return layout
    }
}
