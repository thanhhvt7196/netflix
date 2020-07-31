//
//  MovieItemCollectionViewCell.swift
//  netflix
//
//  Created by thanh tien on 7/31/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class MovieItemCollectionViewCell: UICollectionViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: MovieItemCellViewModel!
    private var bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }

    private func prepareUI() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bindViewModel(viewModel: MovieItemCellViewModel) {
        self.viewModel = viewModel
        bindData()
    }
    
    private func bindData() {
        let input = MovieItemCellViewModel.Input()
        let output = viewModel.transform(input: input)
        output.movie
            .compactMap { $0.posterPath }
            .compactMap { ImageHelper.shared.pathToURL(path: $0, imageSize: .w200)}.drive(imageView.rx.imageURL)
            .disposed(by: bag)
    }
}
