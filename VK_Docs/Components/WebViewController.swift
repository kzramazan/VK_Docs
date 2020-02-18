//
//  WebViewController.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/18/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Public Variables
    var currentUrl: URL? {
        return mainWebView.url
    }
    
    // MARK: - Private Variables
    private var progressObserver: NSKeyValueObservation?
    
    // MARK: - Outlets
    var mainWebView: WKWebView = WKWebView()
    
    internal var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0
        progressView.tintColor =  Tint.progressViewColor
        return progressView
    }()
    
    internal lazy var refreshControl =  UIRefreshControl()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        setupWebView()
        addPullToRefresh()
    }
    
    func loadWebView(url: URL) {
        let urlRequest = URLRequest(url: url)
        mainWebView.load(urlRequest)
    }

    // MARK: - Configurations
    private func addPullToRefresh() {
        mainWebView.scrollView.insertSubview(refreshControl, at: 0)
        if #available(iOS 11.0, *) {
            mainWebView.scrollView.contentInsetAdjustmentBehavior = .always
        } else {
        }
        mainWebView.scrollView.showsVerticalScrollIndicator = false
        mainWebView.scrollView.decelerationRate = .fast
    }

    private func setupWebView() {
        mainWebView.scrollView.contentInset = .zero
        mainWebView.scrollView.showsHorizontalScrollIndicator = false
        mainWebView.scrollView.showsVerticalScrollIndicator = false
        mainWebView.contentMode = .top
        setupProgressView()
        observeProgress()
    }

    private func setupProgressView() {
        mainWebView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let views = ["progressView": progressView]
        var constraints: [NSLayoutConstraint] = []
        let verticalFormat = "V:|-0-[progressView]"
        let horizontalFormat = "H:|-0-[progressView]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: verticalFormat, options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: horizontalFormat, options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }
    
    private func observeProgress() {
        progressObserver = mainWebView.observe(\.estimatedProgress, options: [.new]) { [weak self] mainWebView, _ in
            guard let self = self else { return }
            self.progressView.alpha = 1.0
            let newProgress = Float(mainWebView.estimatedProgress)
            self.progressView.setProgress(newProgress, animated: (newProgress >= self.progressView.progress))
            if mainWebView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIView.AnimationOptions(), animations: { [weak self] in
                    guard let self = self else { return }
                    self.progressView.alpha = 0.0
                    }, completion: { [weak self] _ in
                        guard let self = self else { return }
                        self.progressView.progress = 0
                })
            }
        }
    }
    
    // MARK: - Methods
    func reload(clearCache: Bool) {
        if clearCache {
            self.clearCache()
        }
        
        guard let url = mainWebView.url else { return }
        loadWebView(url: url)
    }
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

private extension WebViewController {
    func configUI() {
        view.backgroundColor = .white
        view.addSubview(mainWebView)
        makeConstraints()
    }
    
    func makeConstraints() {
        mainWebView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
}
