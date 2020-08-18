//
//  ViewPager.swift
//  netflix
//
//  Created by thanh tien on 8/18/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import Reusable
import UIKit

enum ViewPagerMode: Int {
    case normal = 0
    case equal = 1
}

enum PagerDirection: CGFloat {
    case left = -1
    case none = 0
    case right = 1
    
    init(value: CGFloat) {
        if value < 0 {
            self = .left
        } else if value > 0 {
            self = .right
        } else {
            self = .none
        }
    }
}

protocol ViewPagerDataSource: class {
    func numberOfPages() -> Int
    func itemsForPages() -> [ViewPagerItem]
    func startAtIndex() -> Int
}

@objc protocol ViewPagerDelegate: class {
    @objc optional func willMoveToIndex(index: Int)
    @objc optional func didMoveToIndex(index: Int)
}

class ViewPager: UIView, NibOwnerLoadable {
    @IBOutlet weak var scrollView: UIScrollView!
    
    private weak var dataSource: ViewPagerDataSource?
    private weak var delegate: ViewPagerDelegate?

    private var tabIndicator = UIView()
    private var tabIndicatorLeadingConstraint: NSLayoutConstraint?
    private var tabIndicatorWidthConstraint: NSLayoutConstraint?
    
    private var tabsViewList = [ViewPagerItem]()
    
    private var currentPageIndex = 0
    private var targetPageIndex: Int?
    private var startOffset: CGFloat = .zero
    private var pagerDirection: PagerDirection = .none
    
    private var itemSpacing: CGFloat = 10
    private var tabIndicatorHeight: CGFloat = 3
    private var tabIndicatorColor = UIColor.red
    private var tabBackgroundColor = UIColor.black
    private var tabHighlightBackgroundColor = UIColor.black
    private var textColor = UIColor.gray
    private var textHighlightColor = UIColor.white
    private var font = UIFont.systemFont(ofSize: 14, weight: .bold)
    private var mode = ViewPagerMode.normal
    
    private var isTransitionInProgress = false

    private func commonInit() {
        loadNibContent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

extension ViewPager {
    @discardableResult
    func set(dataSource: ViewPagerDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }
    
    @discardableResult
    func set(delegate: ViewPagerDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    func set(backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func set(textColor: UIColor) -> Self {
        self.textColor = textColor
        return self
    }
    
    @discardableResult
    func set(textHighlightColor: UIColor) -> Self {
        self.textHighlightColor = textHighlightColor
        return self
    }
    
    @discardableResult
    func set(tabBackgroundColor: UIColor) -> Self {
        self.tabBackgroundColor = tabBackgroundColor
        return self
    }
    
    @discardableResult
    func set(tabHighlightBackgroundColor: UIColor) -> Self {
        self.tabHighlightBackgroundColor = tabHighlightBackgroundColor
        return self
    }
    
    @discardableResult
    func set(tabIndicatorColor: UIColor) -> Self {
        self.tabIndicatorColor = tabIndicatorColor
        return self
    }
    
    @discardableResult
    func set(tabIndicatorHeight: CGFloat) -> Self {
        self.tabIndicatorHeight = tabIndicatorHeight
        return self
    }
    
    @discardableResult
    func set(mode: ViewPagerMode) -> Self {
        self.mode = mode
        return self
    }
    
    @discardableResult
    func set(itemSpacing: CGFloat) -> Self {
        self.itemSpacing = itemSpacing
        return self
    }
}

extension ViewPager {
    func build() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        configScrollView()
        configTabIndicator()
    }
}

extension ViewPager {
    private func setCurrentPageIndex(_ index: Int) {
        currentPageIndex = index
    }
    
    private func setTargetPageIndex(_ index: Int?) {
        targetPageIndex = index
    }
    
    private func setStartOffset(_ offset: CGFloat) {
        startOffset = offset
    }
    
    private func setPagerDirection(_ direction: PagerDirection) {
        pagerDirection = direction
    }
}

extension ViewPager {
    private func configScrollView() {
        scrollView.delegate = self
        scrollView.contentInset = .zero
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isScrollEnabled = true
        let tabViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tabContainerTapped(_:)))
        scrollView.addGestureRecognizer(tabViewTapGesture)
    }
    
    private func configTabIndicator() {
        guard let dataSource = dataSource else { return }
        currentPageIndex = dataSource.startAtIndex()
        let tabs = dataSource.itemsForPages() 
        tabsViewList = tabs
        switch mode {
        case .normal:
            setupTabsForNormalDistribution()
        case .equal:
            setupTabsForEqualDistribution()
        }
        
        addSubView(view: tabIndicator, inView: scrollView)
        tabIndicator.backgroundColor = tabIndicatorColor
        tabIndicator.heightAnchor.constraint(equalToConstant: tabIndicatorHeight).isActive = true
        tabIndicator.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        
        let activeTab = tabsViewList[currentPageIndex]
        tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
        tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
        tabIndicatorLeadingConstraint?.isActive = true
        tabIndicatorWidthConstraint?.isActive = true
        
        tabsViewList[currentPageIndex].addHighlight(backgroundColor: tabHighlightBackgroundColor, textColor: textHighlightColor)

        bringSubviewToFront(scrollView)
    }
    
    private func setupTabsForNormalDistribution() {
        var lastTab: ViewPagerItem?
        var firstTab: ViewPagerItem?
        
        for (index, tabView) in tabsViewList.enumerated() {
            addSubView(view: tabView, inView: scrollView)
            tabView.set(backgroundColor: tabBackgroundColor)
                .set(font: font)
                .set(textColor: textColor)
            
            if index == 0 {
                firstTab = tabView
            }
                        
            tabView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            tabView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            tabView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            tabView.deactiveWidthConstraints()
            tabView.widthAnchor.constraint(equalToConstant: tabView.tabWidth).isActive = true
            
            if let lastTab = lastTab {
                tabView.deactiveLeadingConstraints()
                tabView.leadingAnchor.constraint(equalTo: lastTab.trailingAnchor, constant: itemSpacing).isActive = true
            }
            tabView.tag = index
            lastTab = tabView
        }
        
        lastTab?.deactiveTrailingConstraints()
        lastTab?.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        firstTab?.deactiveLeadingConstraints()
        firstTab?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    }
    
    private func setupTabsForEqualDistribution() {
        var maxWidth: CGFloat = 0
        var lastTab: ViewPagerItem?
        var firstTab: ViewPagerItem?
        
        for (index, tabView) in tabsViewList.enumerated() {
            addSubView(view: tabView, inView: scrollView)
            tabView.set(textColor: textColor)
                .set(font: font)
                .set(backgroundColor: tabBackgroundColor)
            
            if index == 0 {
                firstTab = tabView
            }
            
            tabView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            tabView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            tabView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            maxWidth = max(maxWidth, tabView.tabWidth)
            
            if let lastTab = lastTab {
                tabView.deactiveLeadingConstraints()
                tabView.leadingAnchor.constraint(equalTo: lastTab.trailingAnchor).isActive = true
            }
            
            tabView.tag = index
            lastTab = tabView
        }
        lastTab?.deactiveTrailingConstraints()
        lastTab?.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        firstTab?.deactiveLeadingConstraints()
        firstTab?.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        
        for tabView in tabsViewList {
            tabView.deactiveWidthConstraints()
            tabView.widthAnchor.constraint(equalToConstant: maxWidth).isActive = true
        }
    }
    
    @objc func tabContainerTapped(_ recognizer: UITapGestureRecognizer) {
//        guard !isTransitionInProgress else {
//            return
//        }
        let tapLocation = recognizer.location(in: scrollView)
        let tabViewTapped = scrollView.hitTest(tapLocation, with: nil)
        if let tabIndex = tabViewTapped?.tag, tabIndex != currentPageIndex {
            delegate?.willMoveToIndex?(index: tabIndex)
            setTargetPageIndex(tabIndex)
            tabSelected(at: tabIndex)
            delegate?.didMoveToIndex?(index: tabIndex)
        }
    }
}

extension ViewPager {
    private func setupTabViews(selectedIndex: Int) {
        for (index, tabView) in tabsViewList.enumerated() {
            if index == selectedIndex {
                tabView.addHighlight(backgroundColor: tabHighlightBackgroundColor, textColor: textHighlightColor)
            } else {
                tabView.removeHighlight(backgroundColor: tabBackgroundColor, textColor: textColor)
            }
        }
    }
    
    private func setupCurrentPageIndicator(currentIndex: Int) {
        let activeTab = tabsViewList[currentIndex]
        let activeFrame = activeTab.frame
        setupTabViews(selectedIndex: currentIndex)
        scrollView.scrollRectToVisible(activeFrame, animated: true)
        updateTabIndicatorView()
    }
    
    private func updateTabIndicatorView() {
        let activeTab = tabsViewList[currentPageIndex]
        let activeFrame = activeTab.frame
        
        tabIndicatorLeadingConstraint?.isActive = false
        tabIndicatorWidthConstraint?.isActive = false
        tabIndicatorLeadingConstraint = tabIndicator.leadingAnchor.constraint(equalTo: activeTab.leadingAnchor)
        tabIndicatorWidthConstraint = tabIndicator.widthAnchor.constraint(equalTo: activeTab.widthAnchor)
        
        layoutIfNeeded()
        tabIndicatorWidthConstraint?.isActive = true
        tabIndicatorLeadingConstraint?.isActive = true
        scrollView.scrollRectToVisible(activeFrame, animated: false)
        scrollView.layoutIfNeeded()
    }
    
    private func tabSelected(at index: Int) {
        guard index != currentPageIndex else { return }
        isTransitionInProgress = true
        setupCurrentPageIndicator(currentIndex: index)
    }
    
}

extension ViewPager: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isTransitionInProgress = false
        if let targetIndex = targetPageIndex {
            setCurrentPageIndex(targetIndex)
            setTargetPageIndex(nil)
        }
    }
}

extension ViewPager {
    func addSubView(view: UIView?, inView parentView: UIView) {
        guard let v = view else { return }
        v.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(v)
    }
}
