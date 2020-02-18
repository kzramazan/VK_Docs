//
//  DocumentsProtocol.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

protocol DocumentsProvider {
    func openDocumentWithVC(url: String) -> UIViewController?
}


