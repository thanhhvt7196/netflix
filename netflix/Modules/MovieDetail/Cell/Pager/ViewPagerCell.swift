//
//  ViewPagerCell.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import UIKit
import Reusable
import JXSegmentedView

protocol ViewPagerCellDelegate: class {
    func itemSelected(index: Int)
}

class ViewPagerCell: UITableViewCell, NibReusable {
    @IBOutlet weak var viewPager: JXSegmentedView!
    
    private var startIndex = 0
    private let dataSource = JXSegmentedTitleDataSource()
    private let indicator = JXSegmentedIndicatorLineView()
    
    weak var delegate: ViewPagerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
    private func prepareUI() {
        selectionStyle = .none
        viewPager.delegate = self
        setupDataSource()
        setupIndicator()
    }
    
    private func setupDataSource() {
        dataSource.titles = ["EPISODES", "MORE LIKE THIS"]
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titleNormalColor = .gray
        dataSource.titleSelectedColor = .white
        dataSource.titleNormalFont = .systemFont(ofSize: 14, weight: .bold)
        dataSource.titleSelectedFont = .systemFont(ofSize: 14, weight: .bold)
        dataSource.itemSpacing = 15
        viewPager.defaultSelectedIndex = 0
        viewPager.dataSource = dataSource
    }
    
    private func setupIndicator() {
        indicator.indicatorHeight = 3
        indicator.indicatorColor = .red
        indicator.indicatorPosition = .top
        indicator.lineStyle = .lengthen
        viewPager.indicators = [indicator]
    }
    
    func configCell(titles: [String], startIndex: Int) {
        dataSource.titles = titles
        guard titles.indices.contains(startIndex) else {
            return
        }
        dataSource.reloadData(selectedIndex: startIndex)
    }
}

extension ViewPagerCell: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        delegate?.itemSelected(index: index)
    }
}
