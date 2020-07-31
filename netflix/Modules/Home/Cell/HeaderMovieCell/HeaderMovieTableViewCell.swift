//
//  HeaderMovieTableViewCell.swift
//  netflix
//
//  Created by thanh tien on 7/26/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import Lottie

class HeaderMovieTableViewCell: UITableViewCell, NibReusable, ViewModelBased {
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var myListAnimationView: AnimationView!
    
    var viewModel: HeaderMovieViewModel!
    private var bag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    private func prepareUI() {
        selectionStyle = .none
        playView.layer.cornerRadius = 2
        let addListAnimation = Animation.named("icon-addList")
        myListAnimationView.animation = addListAnimation
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bindViewModel(viewModel: HeaderMovieViewModel) {
        self.viewModel = viewModel
        bindData()
    }
    
    private func bindData() {
        let input = HeaderMovieViewModel.Input()
        let output = viewModel.transform(input: input)

        output.movie
            .map { $0.posterPath }
            .compactMap { $0 }
            .compactMap { ImageHelper.shared.pathToURL(path: $0, imageSize: .original)}
            .drive(posterImageView.rx.imageURL)
            .disposed(by: bag)
        
        output.movie
            .compactMap { $0.genreIds }
            .map { ids -> [String] in
                let allMovieGenres = MovieGenreRealmObject.getAllGenres() ?? []
                let allTVShowsGenres = TVGenreRealmObject.getAllGenres() ?? []
                let genreIds = Set((allTVShowsGenres + allMovieGenres).compactMap { $0.id }).intersection(Set(ids))
                let genreNames = (allTVShowsGenres + allMovieGenres).filter { genre -> Bool in
                    return genreIds.contains(genre.id ?? 0)
                }
                return Array(Set(genreNames.compactMap { $0.name }))
            }
            .map { $0.joined(separator: " • ")}
            .drive(genreLabel.rx.text)
            .disposed(by: bag)
        
        
    }
}
