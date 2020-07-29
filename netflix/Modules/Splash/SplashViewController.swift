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

class SplashViewController: BaseViewController, StoryboardBased {
    @IBOutlet weak var playerView: UIView!
    
    private var isFirstLaunch = true

    override func viewDidLoad() {
        super.viewDidLoad()
        createObserver()
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
    
    @objc private func finishSplashVideo() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }) { _ in
            SceneCoordinator.shared.transition(to: Scene.onboarding)
        }
    }
}
