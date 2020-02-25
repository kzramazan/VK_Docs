//
//  Session.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/25/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import Foundation

class Session {
    static var shared = Session()
    
    var ticket: String?
}
