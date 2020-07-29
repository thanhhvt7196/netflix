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
    let errorTracker = ErrorTracker()
    let activityIndicator = PublishSubject<Bool>()
    private let loginResponse = PublishSubject<(String, String)>()
    
    static func logout(completion: (() -> Void)? = nil) {
        LoginObject.deleteLoginInfo()
        PersistentManager.shared.requestToken = ""
        PersistentManager.shared.sessionID = ""
        PersistentManager.shared.clearWhenExit()
        completion?()
    }
    
    func login(username: String, password: String) -> Observable<(String, String)> {
        activityIndicator.onNext(true)
        createNewRequestToken(username: username, password: password)
        return loginResponse
    }
    
    private func createNewRequestToken(username: String, password: String) {
        HostAPIClient.performApiNetworkCall(router: .createRequestToken, type: NewRequestTokenResponse.self)
            .trackError(errorTracker)
            .subscribe(onNext: { [weak self] tokenResponse in
                guard let self = self, let token = tokenResponse.requestToken else { return }
                self.verifyRequestToken(username: username, password: password, token: token)
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.activityIndicator.onNext(false)
            })
            .disposed(by: bag)
    }
    
    private func verifyRequestToken(username: String, password: String, token: String) {
        HostAPIClient.performApiNetworkCall(router: .verifyRequestToken(username: username, password: password, token: token), type: NewRequestTokenResponse.self)
            .trackError(errorTracker)
            .subscribe(onNext: { [weak self] tokenResponse in
                guard let self = self, let token = tokenResponse.requestToken else { return }
                self.createSession(token: token)
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.activityIndicator.onNext(false)
            })
            .disposed(by: bag)
    }
    
    private func createSession(token: String) {
        HostAPIClient.performApiNetworkCall(router: .createSession(token: token), type: SessionResponse.self)
            .trackError(errorTracker)
            .subscribe(onNext: { [weak self] sessionResponse in
                guard let self = self, let sessionID = sessionResponse.sessionID else { return }
                self.loginResponse.onNext((sessionID, token))
                self.activityIndicator.onNext(false)
            }, onError: { [weak self] _ in
                guard let self = self else { return }
                self.activityIndicator.onNext(false)
            })
            .disposed(by: bag)
    }
}
