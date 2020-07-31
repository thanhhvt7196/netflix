//
//  WebViewController.swift
//  netflix
//
//  Created by thanh tien on 7/29/20.
//  Copyright © 2020 thanh tien. All rights reserved.
//

import Foundation
import UIKit
import Reusable
import RxSwift
import WebKit

class WebViewController: FadeAnimatedViewController, StoryboardBased, ViewModelBased {
    var viewModel: WebViewModel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    private let leftBarButtonItem = UIBarButtonItem(image: Asset.chevronLeftNormal.image, style: .plain, target: self, action: nil)
    private let bag = DisposeBag()
    
    var myContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        handleAction()
        WKWebView.clean()
        removeCachedResponse()
        loadRequest()
    }
    
    override func prepareUI() {
        super.prepareUI()
        configNavigationBar()
        configWebView()
        configProgressBar()
        
    }
    
    private func handleAction() {
        leftBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                SceneCoordinator.shared.pop(animated: true)
            })
            .disposed(by: bag)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let change = change else { return }
        if context != &myContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == "estimatedProgress" {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressBar.progress = progress
            }
            return
        }
    }
}

extension WebViewController {
    private func configNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        logoImageView.center = titleView.center
        logoImageView.image = Asset.netflixLogotypeNormal.image
        logoImageView.contentMode = .scaleAspectFit
        titleView.addSubview(logoImageView)
        navigationItem.titleView = titleView
    }
    
    private func configWebView() {
        webView.configuration.allowsInlineMediaPlayback = false
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: &myContext)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: &myContext)
    }
    
    private func configProgressBar() {
        progressBar.trackTintColor = .clear
        progressBar.progressTintColor = .red
    }
}

extension WebViewController {
    private func removeCachedResponse() {
        URLCache.shared.removeAllCachedResponses()
    }
    
    private func loadRequest() {
        if webView.isLoading {
            webView.stopLoading()
        }
        
        if let url = URL(string: viewModel.initialURL) {
            let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
            webView.load(urlRequest)
        }
    }
}
