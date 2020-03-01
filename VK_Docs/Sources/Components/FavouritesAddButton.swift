//
//  FavouritesAddButton.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class FavouritesAddButton: UIButton {
    var isFavourite: Bool = false {
        didSet {
            if isFavourite {
                self.setTitle("Удалить из избранного", for: .normal)
                self.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1)
                self.setTitleColor(Tint.customButtonColor, for: .normal)
            }else {
                self.setTitle("Добавить в избранное", for: .normal)
                self.backgroundColor = Tint.customButtonColor
                self.setTitleColor(.white, for: .normal)
            }
        }
    }
}
