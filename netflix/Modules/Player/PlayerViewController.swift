//
//  PlayerViewController.swift
//  netflix
//
//  Created by thanh tien on 9/3/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Reusable
import AVKit
import XCDYouTubeKit

class PlayerViewController: UIViewController, ViewModelBased, StoryboardBased {
    var viewModel: PlayerViewModel!
    private let bag = DisposeBag()
    
    private let loadVideoTrigger = PublishSubject<Void>()
    private var player: AVPlayer?
    private var isFirstLaunch = true
    private let playerView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        loadVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            configPlayer()
            isFirstLaunch = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func bind() {
        let input = PlayerViewModel.Input(loadVideoTrigger: loadVideoTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.url
            .drive(onNext: { [weak self] url in
                guard let self = self else { return }
                self.play(url: url)
            })
            .disposed(by: bag)
        
        output.isLoading.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
        
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                print(UIDevice.current.orientation.rawValue)
            })
            .disposed(by: bag)
    }
}

extension PlayerViewController {
    private func configPlayer() {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        playerView.frame = CGRect(x: -(height - width)/2, y: (height - width)/2, width: height, height: width)
        view.addSubview(playerView)
        playerView.transform = CGAffineTransform(rotationAngle: .pi/2)
    }
}

extension PlayerViewController {
    private func loadVideo() {
        loadVideoTrigger.onNext(())
    }
    
    private func play(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerLayer.videoGravity = .resizeAspect
        playerView.layer.addSublayer(playerLayer)
        player?.play()
    }
}
