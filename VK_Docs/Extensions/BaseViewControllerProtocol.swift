//
//  BaseViewControllerProtocol.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import SVProgressHUD

/// Протокол для базовых ViewController-ов
protocol BaseViewControllerProtocol: AnyObject {}

extension BaseViewControllerProtocol where Self: UIViewController {
    
    /// Событие произошло успешно
    ///
    /// - Parameter message: сообщение
    func showSuccess(message: String?) {
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    /// Показать ошибку
    ///
    /// - Parameter message: сообщение об ошибке
    func showError(message: String?) {
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    /// Показать индикатор
    ///
    /// - Parameter status: описание индикатора
    func showActivityIndicator(withStatus status: String? = nil) {
        SVProgressHUD.show(withStatus: status)
    }
    
    /// Скрыть индикатор
    func hideActivityIndicator() {
        SVProgressHUD.dismiss()
        (self as? UITableViewController)?.refreshControl?.endRefreshing()
    }
}
