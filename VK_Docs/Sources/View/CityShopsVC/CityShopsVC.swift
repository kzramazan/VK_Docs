//
//  CityShopsVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/25/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class CityShopsVC: UIViewController {
    private let viewModel = CityShopsViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
        
//        updateList()
    }
    


}

extension CityShopsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(CityShopsTableViewCell.self)!
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

private extension CityShopsVC {
    //MARK: - Requests
    
    
    //MARK: - Methods
    
    
    
    //MARK: - Actions
    func updateList() {
        
    }
    
    
    
    //MARK: - ConfigUI
    func configUI() {
        view.addSubview(tableView)
        
        makeConstraints()
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
