//
//  HomeNowPlayingCellViewModel.swift
//  netflix
//
//  Created by thanh tien on 7/30/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HomePreviewListCellViewModel: ViewModel {
    private let medias: [Media]
    private let mediaType: MediaType
    let rowIndexPath: IndexPath
    
    init(medias: [Media], mediaType: MediaType, indexPath: IndexPath) {
        self.medias = medias.filter { !$0.posterPath.isNilOrEmpty }
        self.mediaType = mediaType
        self.rowIndexPath = indexPath
    }
    
    func transform(input: Input) -> Output {
        return Output(medias: .just(medias))
    }
}

extension HomePreviewListCellViewModel {
    struct Input {
        var itemSelected: Driver<IndexPath>
    }
    
    struct Output {
        var medias: Driver<[Media]>
    }
}
