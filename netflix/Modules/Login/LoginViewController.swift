//
//  LoginViewController.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextfield: FloatingTextfield!
    @IBOutlet weak var passwordTextfield: FloatingTextfield!
    
    var viewModel: LoginViewModel!
    private let bag = DisposeBag()
    private let loginInfo = PublishSubject<LoginObject>()
    
    private let leftBarButtonItem = UIBarButtonItem(image: Asset.chevronLeftNormal.image, style: .plain, target: self, action: nil)
    private let rightBarButtonItem = UIBarButtonItem(title: Strings.help, style: .done, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        bind()
        handleAction()
    }
    
    override func prepareUI() {
        super.prepareUI()
        configNavigationBar()
        configTextfield()
        configButton()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            var aRect = self.view.frame
            aRect.size.height -= keyboardHeight
            var signInButtonBottomPoint = signInButton.frame.origin
            signInButtonBottomPoint.y += signInButton.frame.height
            if aRect.contains(signInButtonBottomPoint) {
                scrollView.scrollRectToVisible(passwordTextfield.frame, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardHeight, right: 0)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bind() {
        let input = LoginViewModel.Input(loginInfo: loginInfo.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.loginResult
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription)
                case .success:
                    SceneCoordinator.shared.transition(to: Scene.tabbar)
                }
            })
            .disposed(by: bag)
        
        output.activityIndicator.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
    }
    
    private func handleAction() {
        signInButton.rx.tap
            .withLatestFrom(Observable.combineLatest(usernameTextfield.rx.text, passwordTextfield.rx.text))
            .subscribe(onNext: { [weak self] username, password in
                guard let self = self else { return }
                let loginObject = LoginObject(username: username, password: password)
                self.loginInfo.onNext(loginObject)
                self.view.endEditing(true)
            })
            .disposed(by: bag)
        
        Observable.combineLatest(usernameTextfield.isValid, passwordTextfield.isValid)
            .subscribe(onNext: { [weak self] usernameIsValid, passwordIsValid in
                guard let self = self else { return }
                let isValid = usernameIsValid && passwordIsValid
                self.signInButton.backgroundColor = isValid ? .red : .clear
                self.signInButton.setTitleColor(isValid ? .white : .gray4, for: .normal)
                self.signInButton.isEnabled = isValid
            })
            .disposed(by: bag)
        
        leftBarButtonItem.rx.tap
            .subscribe(onNext: { _ in
                SceneCoordinator.shared.pop(animated: true)
            })
            .disposed(by: bag)
        
        rightBarButtonItem.rx.tap
            .subscribe(onNext: { _ in
                SceneCoordinator.shared.transition(to: Scene.webView(url: Constants.helpURL))
            })
            .disposed(by: bag)
    }
}

extension LoginViewController {
    private func configNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        logoImageView.center = titleView.center
        logoImageView.image = Asset.netflixLogotypeNormal.image
        logoImageView.contentMode = .scaleAspectFit
        titleView.addSubview(logoImageView)
        navigationItem.titleView = titleView
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
        rightBarButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .selected)
    }
    
    private func configTextfield() {
        usernameTextfield.setup(setting:
            FloatingTextfieldSettingBuilder.shared()
            .placeholer(Strings.username)
            .inputType(.username)
            .cornerRadius(5)
            .build())
        
        passwordTextfield.setup(setting: FloatingTextfieldSettingBuilder.shared()
            .placeholer(Strings.password)
            .inputType(.password)
            .isSecureEntry(true)
            .toggleSecureEntryEnabled(true)
            .cornerRadius(5)
            .build())
    }
    
    private func configButton() {
        signInButton.layer.cornerRadius = 5
    }
}
