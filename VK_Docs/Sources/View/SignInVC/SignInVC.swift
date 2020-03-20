//
//  SignInVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/16/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import VK_ios_sdk

typealias SuccessCompletion = (() -> Void)
typealias ErrorCompletion = ((String?) -> Void)

class SignInVC: UIViewController {
    
    @IBOutlet weak var backgrounView: UIView!
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        VKSdk.initialize(withAppId: Constants.vkAppID)
        VKSdk.instance()?.register(self)
        VKSdk.instance().uiDelegate = self
        let accesses = [VK_PER_FRIENDS, VK_PER_EMAIL, VK_PER_DOCS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_MARKET]
        VKSdk.wakeUpSession(accesses) { (state, error) in
//            guard let self = self else { return }
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            VKSdk.authorize(accesses, with: .disableSafariController)
//            if state == .authorized {
//                self.goToNeededVC()
//            }else {
//                VKSdk.authorize(["friends", "email", "docs", "wall", "photos", "nohttps"], with: .disableSafariController)
//            }
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
        goToNeededVC()
    }
    
    func goToNeededVC() {
        goToPhotoAlbumsVC()
    }
    
    func goToPhotoAlbumsVC() {
        let vc = MainTabBarController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        navigationController?.present(vc, animated: true)
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
        UserDefaults.standard.set(result.token.accessToken, forKey: Constants.tokenKey)
        UserDefaults.standard.synchronize()
        
        print("User token: \(String(describing: result.token.accessToken))")
        Session.shared.ticket = result.token.accessToken
        goToNeededVC()
        
    }
    
    func vkSdkReceivedNewToken(newToken: VKAccessToken) {
        UserDefaults.standard.set(newToken, forKey: Constants.tokenKey)
        UserDefaults.standard.synchronize()
        Session.shared.ticket = newToken.accessToken
        print("Token Key: ", newToken)
    }
}
