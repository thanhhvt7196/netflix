//
//  HomeChooseCategoryCell.swift
//  netflix
//
//  Created by thanh tien on 7/24/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable

class HomeChooseCategoryCell: UITableViewCell, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func prepareUI() {
        selectionStyle = .none
    }
    
    func configCell(genre: Genre) {
        titleLabel.text = genre.name
        if genre == PersistentManager.shared.currentGenre {
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        } else {
            titleLabel.textColor = .lightGray
            titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        }
    }
}
