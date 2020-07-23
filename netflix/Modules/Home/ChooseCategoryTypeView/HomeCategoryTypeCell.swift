//
//  HomeCategoryTypeCell.swift
//  netflix
//
//  Created by thanh tien on 7/23/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable

class HomeCategoryTypeCell: UITableViewCell, NibReusable {
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
    
    func configCell(type: CategoryType) {
        titleLabel.text = type.rawValue
        if type == PersistentManager.shared.categoryType {
            titleLabel.textColor = .white
            titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        } else {
            titleLabel.textColor = .lightGray
            titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        }
    }
}
