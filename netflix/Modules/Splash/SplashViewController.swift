//
//  SplashViewController.swift
//  netflix
//
//  Created by thanh tien on 7/29/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable
import AVKit
import RxSwift
import RxCocoa

class SplashViewController: BaseViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var playerView: UIView!

    var viewModel: SplashViewModel!
    private let bag = DisposeBag()
    private var isFirstLaunch = true
    
    private let videoEnd = PublishSubject<Void>()
    private let loginObject = PublishSubject<LoginObject?>()

    override func viewDidLoad() {
        super.viewDidLoad()
        createObserver()
        bind()
        getLoginInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            playVideo()
            isFirstLaunch = false
        }
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(finishSplashVideo), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func bind() {
        let input = SplashViewModel.Input(
            loginInfo: loginObject.asDriverOnErrorJustComplete(),
            videoEnd: videoEnd.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input: input)
        
        output.splashFinish
            .drive(onNext: { result in
                ProgressHUD.shared.hide()
                switch result {
                case .failure:
                    SceneCoordinator.shared.transition(to: Scene.onboarding)
                case .success:
                    SceneCoordinator.shared.transition(to: Scene.tabbar)
                }
            })
            .disposed(by: bag)
    }
    
    @objc private func finishSplashVideo() {
        ProgressHUD.shared.show()
        videoEnd.onNext(())
        playerView.alpha = 0
    }
}

extension SplashViewController {
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "Netflix_N_video", ofType:"mp4") else {
            debugPrint("video not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerLayer.videoGravity = .resizeAspect
        playerView.layer.addSublayer(playerLayer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            player.play()
        }
    }
}

extension SplashViewController {
    private func getLoginInfo() {
        let loginInfo = LoginObject.getLoginObject()
        loginObject.onNext(loginInfo)
    }
}
