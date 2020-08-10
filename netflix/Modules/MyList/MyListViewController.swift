//
//  MyListViewController.swift
//  netflix
//
//  Created by thanh tien on 7/21/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class MyListViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: MyListViewModel!
    
    private let bag = DisposeBag()
    
    private let fetchDataTrigger = PublishSubject<Void>()
    private let clearDataTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        if viewModel.isTabbarItem {
            loadData()
        }
    }
    
    override func prepareUI() {
        super.prepareUI()
        configCollectionView()
    }
    
    private func bind() {
        let input = MyListViewModel.Input(
            fetchDataTrigger: fetchDataTrigger.asDriverOnErrorJustComplete(),
            clearDataTrigger: clearDataTrigger.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.mylist
            .drive(collectionView.rx.items) { collectionView, item, movie in
                let indexPath = IndexPath(item: item, section: 0)
                let cell = collectionView.dequeueReusableCell(for: indexPath) as MovieItemCollectionViewCell
                let itemViewModel = MovieItemCellViewModel(movie: movie)
                cell.bindViewModel(viewModel: itemViewModel)
                return cell
            }
            .disposed(by: bag)
            
        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showErrorAlert(message: error.localizedDescription)
            })
            .disposed(by: bag)
        
        output.loading.drive(ProgressHUD.rx.isAnimating).disposed(by: bag)
    }
}

extension MyListViewController {
    private func configCollectionView() {
        let numberOfItemPerRow: CGFloat = 3.0
        let spacing: CGFloat = 10
        let padding: CGFloat = 15
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        let itemWidth = (UIScreen.main.bounds.width - padding * 2 - (numberOfItemPerRow - 1) * spacing) / numberOfItemPerRow
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(cellType: MovieItemCollectionViewCell.self)
    }
}

extension MyListViewController {
    func loadData() {
        clearDataTrigger.onNext(())
        fetchDataTrigger.onNext(())
    }
}
