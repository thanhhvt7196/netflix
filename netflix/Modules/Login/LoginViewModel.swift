//
//  LoginViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let userInfoService = UserInfoService()
        let session = input.loginInfo.flatMapLatest { loginObject -> Driver<(String, String)> in
            guard let username = loginObject.username, let password = loginObject.password else { return .empty() }
            return userInfoService.login(username: username, password: password)
                .asDriverOnErrorJustComplete()
        }
        return Output(
            session: session, error: userInfoService.errorTracker.asDriver(),
            activityIndicator: userInfoService.activityIndicator.asDriver(onErrorJustReturn: false))
    }
    
    private func createNewRequestToken() -> Observable<NewRequestTokenResponse> {
        return HostAPIClient.performApiNetworkCall(router: .createRequestToken, type: NewRequestTokenResponse.self)
    }
    
    private func verifyRequestToken(username: String, password: String, token: String) -> Observable<NewRequestTokenResponse> {
        return HostAPIClient.performApiNetworkCall(router: .verifyRequestToken(username: username, password: password, token: token), type: NewRequestTokenResponse.self)
    }
    
    private func createSession(token: String) -> Observable<SessionResponse> {
        return HostAPIClient.performApiNetworkCall(router: .createSession(token: token), type: SessionResponse.self)
    }
}

extension LoginViewModel {
    struct Input {
        var loginInfo: Driver<LoginObject>
    }
    
    struct Output {
        var session: Driver<(String, String)>
        var error: Driver<Error>
        var activityIndicator: Driver<Bool>
    }
}
