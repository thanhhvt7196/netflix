//
//  MovieDetailVideoCell.swift
//  netflix
//
//  Created by thanh tien on 8/20/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable

class MovieDetailVideoCell: UITableViewCell, NibReusable {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var playIcon: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        
    }
    
    private func prepareUI() {
        selectionStyle = .none
        playIcon.layer.cornerRadius = playIcon.bounds.height/2
        playIcon.layer.borderColor = UIColor.white.cgColor
        playIcon.layer.borderWidth = 1
        playIcon.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bannerImageView.image = nil
        titleLabel.text = nil
        typeLabel.text = nil
    }
    
    func configCell(video: Video) {
        if let key = video.key, let url = URL(string: String(format: APIURL.youtubeImageURL, key)) {
            bannerImageView.sd_setImage(with: url, placeholderImage: UIColor.black.toImage())
        } else {
            bannerImageView.image = nil
        }
        titleLabel.text = video.name
        typeLabel.text = video.type
    }
}
