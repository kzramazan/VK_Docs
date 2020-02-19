//
//  AnyDocuments.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
class AnyDocument: UIViewController, DocumentsProvider {
    func openDocumentWithVC(url: String) -> UIViewController? {
        return nil
    }
    
}

class PDFDocument: AnyDocument, WebViewOpenable {
    override func openDocumentWithVC(url: String) -> UIViewController? {
        return getLoadedWebViewVC(with: URL(string: url))
    }
}

class ImageDocument: AnyDocument, QuickLookOpenable {
    override func openDocumentWithVC(url: String) -> UIViewController? {
        return getLoadedQuickLookVC(with: URL(string: url))
    }
}
