//
//  PlayerViewModel.swift
//  netflix
//
//  Created by thanh tien on 9/3/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import XCDYouTubeKit

class PlayerViewModel: ViewModel {
    private let video: Video
    private let isLoading = BehaviorRelay<Bool>(value: false)
    
    init(video: Video) {
        self.video = video
    }
    
    func transform(input: Input) -> Output {
        let url = input.loadVideoTrigger.flatMapLatest { [unowned self] in
            return self.getVideoURL().asDriverOnErrorJustComplete()
        }
        return Output(url: url,
                      isLoading: isLoading.asDriver())
    }
}

extension PlayerViewModel {
    private func getVideoURL() -> Observable<URL> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.isLoading.accept(true)
            let client = XCDYouTubeClient()
            client.getVideoWithIdentifier(self.video.key) { youtubeVideo, error in
                if let youtubeVideo = youtubeVideo {
                    let streamURLs = youtubeVideo.streamURLs
                    guard let streamURL = streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming]
                        ?? streamURLs[XCDYouTubeVideoQuality.HD1080.rawValue]
                        ?? streamURLs[XCDYouTubeVideoQuality.HD720.rawValue]
                        ?? streamURLs[XCDYouTubeVideoQuality.medium360.rawValue]
                        ?? streamURLs[XCDYouTubeVideoQuality.small240.rawValue]
                    else {
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(streamURL)
                    observer.onCompleted()
                } else {
                    observer.onCompleted()
                }
                self.isLoading.accept(false)
            }
            return Disposables.create()
        }
    }
}

extension PlayerViewModel {
    struct Input {
        var loadVideoTrigger: Driver<Void>
    }
    
    struct Output {
        var url: Driver<URL>
        var isLoading: Driver<Bool>
    }
}
