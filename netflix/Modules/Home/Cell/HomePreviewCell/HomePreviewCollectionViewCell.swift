//
//  HomePreviewCollectionViewCell.swift
//  netflix
//
//  Created by thanh tien on 7/30/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class HomePreviewCollectionViewCell: UICollectionViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: HomePreviewCellViewModel!
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }

    private func prepareUI() {
        imageView.layer.cornerRadius = imageView.bounds.height/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bindViewModel(viewModel: HomePreviewCellViewModel) {
        self.viewModel = viewModel
        bindData()
    }
    
    private func bindData() {
        let input = HomePreviewCellViewModel.Input()
        let output = viewModel.transform(input: input)
        output.movie
            .compactMap { $0.posterPath }
            .compactMap { ImageHelper.shared.pathToURL(path: $0, imageSize: .w200)}.drive(imageView.rx.imageURL)
            .disposed(by: bag)
    }
}
