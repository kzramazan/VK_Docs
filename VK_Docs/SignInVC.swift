//
//  SignInVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/16/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import VK_ios_sdk
class SignInVC: UIViewController {
    
    @IBOutlet weak var backgrounView: UIView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        VKSdk.initialize(withAppId: AppDelegate.vkAppID)
        VKSdk.instance()?.register(self)
        VKSdk.instance().uiDelegate = self
        
        VKSdk.wakeUpSession(["friends", "email", "docs"]) { (state, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            if state == .authorized {
                let vkApi = VKApi.users()?.get()
                vkApi?.execute(resultBlock: { (response) in
                    let currUser = CurrentUser(object: (response?.json as? NSArray)?[0] as? NSDictionary)
                    CurrentUser.shared = currUser
                }, errorBlock: { (error) in
                    print(error?.localizedDescription)
                })
            }else {
                VKSdk.authorize(["friends", "email", "docs"], with: .disableSafariController)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

//MARK: - UITextFieldDelegate
extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginField:
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            passwordField.resignFirstResponder()
            didTapSignIn(singInButton)
            break
        default:
            break
        }
        return true
    }
}

private extension SignInVC {
    //MARK: - Actions
    @IBAction func didTapSignIn(_ sender: UIButton) {
        
    }
    
    //MARK: - ConfigUI
    func configUI() {
        view.backgroundColor = UIColor(red: 81, green: 139, blue: 203)
        
        backgrounView.layer.cornerRadius = backgrounView.frame.width * 0.03
        loginField.leftViewMode = .always
        loginField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))
        loginField.delegate = self
        
        passwordField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 0)))
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        
        singInButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        singInButton.layer.cornerRadius = singInButton.frame.width * 0.03
    }
}
extension SignInVC: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("Captcha error: ", VKError.description())
    }
}

extension SignInVC: VKSdkDelegate {
    func vkSdkUserAuthorizationFailed() {
        
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("User token: \(result.token)")
    }
    
    func vkSdkReceivedNewToken(newToken: VKAccessToken) {
        UserDefaults.standard.set(newToken, forKey: "TOKEN_KEY")
        UserDefaults.standard.synchronize()
        print(newToken)
    }
}
