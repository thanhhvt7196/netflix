//
//  Services.swift
//  netflix
//
//  Created by thanh tien on 7/28/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class UserInfoService {
    private let bag = DisposeBag()
    let activityIndicator = PublishSubject<Bool>()
    private let loginResult = PublishSubject<Result<Void, Error>>()
    
    static func logout(completion: (() -> Void)? = nil) {
        LoginObject.deleteLoginInfo()
        PersistentManager.shared.requestToken = ""
        PersistentManager.shared.sessionID = ""
        PersistentManager.shared.clearWhenExit()
        completion?()
    }
    
    func login(username: String, password: String) -> Observable<Result<Void, Error>> {
        activityIndicator.onNext(true)
        createNewRequestToken(username: username, password: password)
        return loginResult
    }
    
    private func createNewRequestToken(username: String, password: String) {
        HostAPIClient.performApiNetworkCall(router: .createRequestToken, type: NewRequestTokenResponse.self)
            .subscribe(onNext: { [weak self] tokenResponse in
                guard let self = self, let token = tokenResponse.requestToken else { return }
                self.verifyRequestToken(username: username, password: password, token: token)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.loginResult.onNext(.failure(error))
                self.activityIndicator.onNext(false)
            })
            .disposed(by: bag)
    }
    
    private func verifyRequestToken(username: String, password: String, token: String) {
        HostAPIClient.performApiNetworkCall(router: .verifyRequestToken(username: username, password: password, token: token), type: NewRequestTokenResponse.self)
            .subscribe(onNext: { [weak self] tokenResponse in
                guard let self = self, let token = tokenResponse.requestToken else { return }
                self.createSession(token: token, username: username, password: password)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.loginResult.onNext(.failure(error))
                self.activityIndicator.onNext(false)
            })
            .disposed(by: bag)
    }
    
    private func createSession(token: String, username: String, password: String) {
        HostAPIClient.performApiNetworkCall(router: .createSession(token: token), type: SessionResponse.self)
            .subscribe(onNext: { [weak self] sessionResponse in
                guard let self = self, let sessionID = sessionResponse.sessionID else { return }
                self.loginResult.onNext(.success(()))
                let loginObject = LoginObject(username: username, password: password)
                loginObject.save()
                PersistentManager.shared.sessionID = sessionID
                PersistentManager.shared.requestToken = token
                print("SessionID = \(sessionID)")
                print("token = \(token)")
                self.activityIndicator.onNext(false)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.loginResult.onNext(.failure(error))
                self.activityIndicator.onNext(false)
            })
            .disposed(by: bag)
    }
}
