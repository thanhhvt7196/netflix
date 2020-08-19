//
//  RecommendationMediaCellViewModel.swift
//  netflix
//
//  Created by thanh tien on 8/20/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RecommendationMediaCellViewModel: ViewModel {
    private let medias: [Media]
    private let mediaType: MediaType
    private let bag = DisposeBag()
    
    init(medias: [Media], mediaType: MediaType) {
        self.medias = medias
        self.mediaType = mediaType
    }
    func transform(input: Input) -> Output {
        input.selectedMedia
            .drive(onNext: { [weak self] index in
                guard let self = self, self.medias.indices.contains(index) else { return }
                switch self.mediaType {
                case .movie:
                    SceneCoordinator.shared.transition(to: Scene.movieDetail(movie: self.medias[index]))
                case .tv:
                    break
                }
            })
            .disposed(by: bag)
        return Output(medias: .just(medias))
    }
}

extension RecommendationMediaCellViewModel {
    struct Input {
        var selectedMedia: Driver<Int>
    }
    
    struct Output {
        var medias: Driver<[Media]>
    }
}
