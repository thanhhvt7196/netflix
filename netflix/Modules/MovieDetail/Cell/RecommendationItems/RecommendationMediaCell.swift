//
//  RecommendationMediaCell.swift
//  netflix
//
//  Created by thanh tien on 8/20/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class RecommendationMediaCell: UITableViewCell, NibReusable, ViewModelBased {
    @IBOutlet var bannerImageViews: [UIImageView]!
    @IBOutlet var selectButtons: [UIButton]!
    
    var viewModel: RecommendationMediaCellViewModel!
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    private func prepareUI() {
        selectionStyle = .none
        bannerImageViews.forEach({ $0.sd_imageTransition = .fade })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
        bannerImageViews.forEach { $0.alpha = 0}
    }
    
    func bindViewModel(viewModel: RecommendationMediaCellViewModel) {
        self.viewModel = viewModel
        bindData()
    }
    
    private func bindData() {
        let tags = selectButtons.map { button -> Observable<Int> in
            return button.rx.tap.map { button.tag }
        }
        let selectedMedia = Observable.merge(tags)
        let input = RecommendationMediaCellViewModel.Input(selectedMedia: selectedMedia.asDriverOnErrorJustComplete())
        
        let output = viewModel.transform(input: input)
        
        output.medias
            .map { $0.map { $0.posterPath }}
            .map { $0.map { ImageHelper.shared.pathToURL(path: $0, imageSize: .w200) }}
            .drive(onNext: { [weak self] urls in
                guard let self = self else { return }
                self.bannerImageViews.enumerated().forEach { index, imageView in
                    if urls.indices.contains(index) {
                        imageView.alpha = 1
                        imageView.setImageWithPlaceHolder(url: urls[index])
                    } else {
                        imageView.image = nil
                        imageView.alpha = 0
                    }
                }
            })
            .disposed(by: bag)
    }
}
