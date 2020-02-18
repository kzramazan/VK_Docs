//
//  ViewController.swift
//  VK_Docs
//
//  Created by Ramazan Kazybek on 2/16/20.
//  Copyright © 2020 Ramazan Kazybek. All rights reserved.
//

import UIKit
import PDFKit
import VK_ios_sdk

class DocumentsVC: UIViewController, BaseViewControllerProtocol {
    private let viewModel = DocumentViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white

        tableView.separatorInset = .zero
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
        getDocumentList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar()
    }
    
    private func setNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let label = UILabel()
        label.font = UIFont(name: "ArialMT", size: 17)
        navigationController?.navigationBar.backgroundColor = .white
        label.text = "Документы"
        self.navigationItem.titleView = label
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

extension DocumentsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithRegistration(DocumentTableViewCell.self)!
        if let docsArr = viewModel.getList() {
            cell.vkDoc = docsArr[UInt(indexPath.row)]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let docsArr = viewModel.getList() {
            openDocument(vkDocs: docsArr[UInt(indexPath.row)])
        }
    }
}

private extension DocumentsVC {
    //MARK: - Actions
    func getDocumentList() {
        viewModel.getDocumentList(success: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.showError(message: error)
        }
    }
    
    func openDocument(vkDocs: VKDocs) {
        guard let typeInt = vkDocs.type as? Int,
            let type = VKDocsStruct.VKDocsExt(rawValue: typeInt),
            let url = vkDocs.url else { return }
        
        guard let vc = type.makeDocument().openDocumentWithVC(url: url) else { return }

        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - ConfigUI
    func configUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        makeConstraints()
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints { m in
            m.edges.equalToSuperview()
        }
    }
}

extension VKDocsStruct.VKDocsExt {
    
    func makeDocument() -> AnyDocument {
        switch self {
        case .ebook:
            return PDFDocument()
        case .image, .gif:
            return ImageDocument()
        default:
            return PDFDocument()
        }
    }
    
}

