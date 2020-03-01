//
//  SelectionButton.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class SelectionButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.setImage(isEnabled ? #imageLiteral(resourceName: "check_circle") : nil, for: .normal)
        }
    }
}
