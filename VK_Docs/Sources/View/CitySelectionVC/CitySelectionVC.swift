//
//  CitySelectionVC.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 3/1/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit


protocol CitySelectionDelegate where Self: UIViewController {
    func idForSelectedCity(city: City)
}

class CitySelectionVC: UIViewController {
    private let viewModel: CitySelectionViewModel
    var delegate: CitySelectionDelegate?
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.mainFontSemiBold(ofSize: 17)
        label.text = "Город"
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        getCities()
    }
    
    init(lastSelectedCity: Int) {
        viewModel = CitySelectionViewModel(lastSelectedCity: lastSelectedCity)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let lastSelectedRow = viewModel.lastSelectedRow {
            delegate?.idForSelectedCity(city: viewModel.getCity(row: lastSelectedRow))
        }
    }
}

extension CitySelectionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(SelectionTableViewCell.self)!
        cell.setCell(city: viewModel.getCity(row: indexPath.row), isSelected: viewModel.getSelectState(row: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCity(row: indexPath.row)
        var updateIndexPaths = [indexPath]
        if let lastSelectedRow = viewModel.lastSelectedRow {
            viewModel.deselectCity(row: lastSelectedRow)
            updateIndexPaths.append(IndexPath(row: lastSelectedRow, section: 0))
        }
        viewModel.lastSelectedRow = indexPath.row
        tableView.reloadRows(at: updateIndexPaths, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.deselectCity(row: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

private extension CitySelectionVC {
    //MARK: - Requests
    func getCities() {
        viewModel.getCities(success: { [weak self] in
            guard let self = self else { return }
            
            self.tableView.reloadData()
        }) { (_) in
        }
    }
    
    //MARK: - Actions
    @objc func closeBtnTapped() {
        if navigationController == nil {
            self.dismiss(animated: true)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    //MARK: - ConfigUI
    func configUI() {
        self.view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        
        view.addSubview(tableView)
        makeConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
