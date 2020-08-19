//
//  PagerHeaderSection.swift
//  netflix
//
//  Created by thanh tien on 8/19/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import UIKit
import JXSegmentedView

protocol PagerHeaderSectionViewDelegate: class {
    func itemSelected(at index: Int)
}

class PagerHeaderSectionView: UIView, NibOwnerLoadable {
    @IBOutlet weak var segmentedView: JXSegmentedView!
    
    fileprivate let dataSource = JXSegmentedTitleDataSource()
    private let indicator = JXSegmentedIndicatorLineView()
    
    weak var delegate: PagerHeaderSectionViewDelegate?
    
    override var backgroundColor: UIColor? {
        didSet {
            segmentedView.backgroundColor = backgroundColor
        }
    }
    
    private func commonInit() {
        loadNibContent()
        configDataSource()
        configIndicator()
        configSegmentedView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setTitles(titles: [String]) {
        dataSource.titles = titles
        segmentedView.dataSource = dataSource
    }
}

extension PagerHeaderSectionView {
    private func configSegmentedView() {
        segmentedView.delegate = self
        segmentedView.indicators = [indicator]
    }
    
    private func configDataSource() {
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titleNormalColor = .gray
        dataSource.titleSelectedColor = .white
        dataSource.titleNormalFont = .systemFont(ofSize: 14, weight: .semibold)
        dataSource.titleSelectedFont = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private func configIndicator() {
        indicator.indicatorPosition = .top
        indicator.indicatorColor = .red
        indicator.indicatorHeight = 3
    }
}

extension PagerHeaderSectionView: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        delegate?.itemSelected(at: index)
    }
}
