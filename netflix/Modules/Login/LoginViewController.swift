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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        handleAction()
    }
    
    override func prepareUI() {
        super.prepareUI()
        configTextfield()
        configButton()
    }
    
    private func bind() {
//        let input = LoginViewModel.Input(createRequestTokenTrigger: createRequestTokenTrigger.asDriverOnErrorJustComplete(), verifyRequestTokenTrigger: verifyRequestTokenTrigger.asDriverOnErrorJustComplete(), createSessionTrigger: createSessionTrigger.asDriverOnErrorJustComplete())
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
    }
}

extension LoginViewController {
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
