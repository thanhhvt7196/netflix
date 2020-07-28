//
//  OnboardingViewController.swift
//  netflix
//
//  Created by thanh tien on 7/28/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import RxCocoa

class OnboardingViewController: BaseViewController, StoryboardBased {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var isFirstLaunch = true
    private let helpButtonItem = UIBarButtonItem(title: Strings.help, style: .done, target: self, action: #selector(showHelpScreen))
    private let privacyButtonItem = UIBarButtonItem(title: Strings.privacy, style: .done, target: self, action: #selector(showPrivacyScreen))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var subviews = [UIView]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLaunch {
            addChildViews()
            isFirstLaunch = false
        }
    }
    
    override func prepareUI() {
        super.prepareUI()
        configScrollView()
        configPageControl()
        configButton()
        configNavigationBar()
    }
}

extension OnboardingViewController {
    private func configScrollView() {
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func configPageControl() {
        pageControl.hidesForSinglePage = true
        pageControl.tintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .red
    }
    
    private func configButton() {
        signinButton.backgroundColor = .red
        signinButton.setTitleColor(.white, for: .normal)
        signinButton.layer.cornerRadius = 3
    }
    
    private func configNavigationBar() {
        navigationItem.rightBarButtonItems = [privacyButtonItem, helpButtonItem]
        navigationController?.navigationBar.tintColor = .white
        helpButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)], for: .normal)
        privacyButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)], for: .normal)
    }
}

extension OnboardingViewController {
    private func childViews() -> [UIView] {
        return [OnboardingView1(), OnboardingView2(), OnboardingView3()]
    }
    
    private func addChildViews() {
        subviews = childViews()
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(subviews.count), height: scrollView.frame.height)
        subviews.enumerated().forEach { (index, onboardingView) in
            onboardingView.frame = CGRect(x: scrollView.frame.width * CGFloat(index), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(onboardingView)
        }
        pageControl.numberOfPages = subviews.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
}

extension OnboardingViewController {
    @objc private func showHelpScreen() {
        
    }
    
    @objc private func showPrivacyScreen() {
        
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            if subviews.indices.contains(pageControl.currentPage) {
                subviews[pageControl.currentPage].backgroundColor = bgColor
            }
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
}

extension OnboardingViewController {
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
