//
//  GoodsInCityVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/29/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit

class NavTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.semanticContentAttribute = .forceRightToLeft
        self.setImage(#imageLiteral(resourceName: "dropdown").withRenderingMode(.alwaysTemplate), for: .normal)
        self.imageView?.tintColor = UIColor(hex: "#3F8AE0")
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        self.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeCity(city: String) {
        self.setTitle("Магазины в \(city)е", for: .normal)
    }
}

class GoodsInCityVC: UIViewController, Refreshable {
    internal lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(getMarketList), for: .valueChanged)
        
        return control
    }()
    
    private lazy var navButton: NavTitleButton = {
        let button = NavTitleButton()
        button.addTarget(self, action: #selector(changeCityTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let viewModel = GoodsInCityViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMarketList()
        configUI()
    }

}

//MARK: - UITableViewDelegate
extension GoodsInCityVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(MarketGroupTableViewCell.self)!
        cell.setCell(market: viewModel.getMarket(row: indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = viewModel.getMarket(row: indexPath.row)
        goToMarketGroup(groupID: group.id, groupName: group.name)
    }
}


extension GoodsInCityVC: CitySelectionDelegate {
    func idForSelectedCity(city: City) {
        if viewModel.selectedCity?.id != city.id {
            viewModel.selectedCity = city
            getMarketList()
        }
    }
}
private extension GoodsInCityVC {
    //MARK: - Requests
    @objc func getMarketList() {
        self.startRefreshing()
        viewModel.getMarketList(success: { [weak self] in
            guard let self = self else { return }
            print(self.viewModel.getMarketList())
            self.stopRefreshing()
            if let title = self.viewModel.selectedCity?.title {
                self.setNavItem(title: title)
            }
            
            self.tableView.reloadData()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.stopRefreshing()
        }
    }
    
    //MARK: - Methods
    func goToMarketGroup(groupID: Int, groupName: String?) {
        let vc = GoodsInGroupsVC(groupID: groupID, groupName: groupName)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Actions
    @objc func changeCityTapped() {
        let vc = CitySelectionVC(lastSelectedCity: viewModel.selectedCity?.id ?? 1)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
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
    
    func setNavItem(title: String) {
        navButton.setTitle("Магазины в \(title)е", for: .normal)
        navigationItem.titleView = navButton
        
        navigationItem.backBarButtonItem = UIBarButtonItem()
    }
}
