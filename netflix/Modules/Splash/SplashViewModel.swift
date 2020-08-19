//
//  SplashViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/30/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SplashViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let videoEnd = input.videoEnd.asObservable()
        let userInfoService = UserInfoService()
        
        let loginResult = input.loginInfo.asObservable().flatMapLatest { loginObject -> Observable<Result<Void, Error>> in
            guard let username = loginObject?.username, let password = loginObject?.password else {
                return .just(.failure(APIError(status_code: nil, status_message: ErrorMessage.errorOccur)))
            }
            return userInfoService.login(username: username, password: password)
        }
        
        let splashFinish = Observable
            .zip(videoEnd, loginResult)
            .map { $0.1 }
            .asDriverOnErrorJustComplete()
        
        return Output(splashFinish: splashFinish,
                      indicator: userInfoService.activityIndicator.asDriver(onErrorJustReturn: false))
    }
}

extension SplashViewModel {
    struct Input {
        var loginInfo: Driver<LoginObject?>
        var videoEnd: Driver<Void>
    }
    
    struct Output {
        var splashFinish: Driver<Result<Void, Error>>
        var indicator: Driver<Bool>
    }
}
