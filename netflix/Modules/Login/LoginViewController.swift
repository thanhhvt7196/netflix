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
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var usernameTextfield: FloatingTextfield!
    @IBOutlet weak var passwordTextfield: FloatingTextfield!
    
    var viewModel: LoginViewModel!
    private let bag = DisposeBag()
    private let createRequestTokenTrigger = PublishSubject<Void>()
    private let verifyRequestTokenTrigger = PublishSubject<LoginObject>()
    private let createSessionTrigger = PublishSubject<String>()
    
    private let leftBarButtonItem = UIBarButtonItem(image: Asset.chevronLeftNormal.image, style: .plain, target: self, action: nil)
    private let rightBarButtonItem = UIBarButtonItem(title: Strings.help, style: .done, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        handleAction()
    }
    
    override func prepareUI() {
        super.prepareUI()
        configNavigationBar()
        configTextfield()
        configButton()
    }
    
    private func bind() {
        let input = LoginViewModel.Input(createRequestTokenTrigger: createRequestTokenTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.session
            .drive(onNext: { sessionID, token in
                print("SessionID = \(sessionID)")
                PersistentManager.shared.requestToken = token
                PersistentManager.shared.sessionID = sessionID
            })
            .disposed(by: bag)
        
        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
        
        output.activityIndicator.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
    }
    
    private func handleAction() {
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.createRequestTokenTrigger.onNext(())
            })
            .disposed(by: bag)
        
        Observable.combineLatest(usernameTextfield.isValid, passwordTextfield.isValid)
            .subscribe(onNext: { [weak self] usernameIsValid, passwordIsValid in
                guard let self = self else { return }
                let isValid = usernameIsValid && passwordIsValid
                self.signInButton.backgroundColor = isValid ? .red : .clear
                self.signInButton.setTitleColor(isValid ? .white : .gray4, for: .normal)
            })
            .disposed(by: bag)
        
        leftBarButtonItem.rx.tap
            .subscribe(onNext: { _ in
                SceneCoordinator.shared.pop(animated: true)
            })
            .disposed(by: bag)
    }
}

extension LoginViewController {
    private func configNavigationBar() {
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
