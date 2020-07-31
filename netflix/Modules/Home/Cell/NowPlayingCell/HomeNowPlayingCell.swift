//
//  HomeNowPlayingCell.swift
//  netflix
//
//  Created by thanh tien on 7/30/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class HomeNowPlayingCell: UITableViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: HomeNowPlayingCellViewModel!
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    private func prepareUI() {
        selectionStyle = .none
        configCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bindViewModel(viewModel: HomeNowPlayingCellViewModel) {
        self.viewModel = viewModel
        bindData()
    }
    
    private func bindData() {
        let input = HomeNowPlayingCellViewModel.Input(itemSelected: collectionView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        output.movies
            .drive(collectionView.rx.items) { collectionView, item, movie in
                let indexPath = IndexPath(item: item, section: 0)
                let cell = collectionView.dequeueReusableCell(for: indexPath) as HomePreviewCollectionViewCell
                let homePreviewCellViewModel = HomePreviewCellViewModel(movie: movie)
                cell.bindViewModel(viewModel: homePreviewCellViewModel)
                return cell
            }
            .disposed(by: bag)
    }
}

extension HomeNowPlayingCell {
    private func configCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(cellType: HomePreviewCollectionViewCell.self)
    }
}
