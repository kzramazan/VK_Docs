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



class DocumentsVC: UIViewController, BaseViewControllerProtocol, Refreshable {
    private let viewModel = DocumentViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white

        tableView.separatorInset = .zero
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = self.refreshControl
        return tableView
    }()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setTargets()
        
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
            cell.setCell(with: docsArr[UInt(indexPath.row)], at: indexPath.row)
            cell.delegate = self
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
    //MARK: - Methods
    func setTargets() {
        refreshControl.addTarget(self, action: #selector(getDocumentList), for: .valueChanged)
    }
    
    func openDocument(vkDocs: VKDocs) {
        guard let typeInt = vkDocs.type as? Int,
            let type = VKDocsStruct.VKDocsExt(rawValue: typeInt),
            let url = vkDocs.url else { return }
        
        guard let vc = type.makeDocument().openDocumentWithVC(url: url) else { return }

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteFromTableView(row: Int) {
        tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .left)
    }
    
    func showEditAlert(vkDoc: VKDocs, row: Int) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        sheet.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = vkDoc.title
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default, handler: { alert -> Void in
            self.editDocument(vkDoc: vkDoc, title: sheet.textFields?[0].text, row: row)
        })
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })

        sheet.addAction(saveAction)
        sheet.addAction(cancelAction)

        self.present(sheet, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    
    
    //MARK: - Requests
    @objc func getDocumentList() {
        startRefreshing()
        viewModel.getDocumentList(success: { [weak self] in
            guard let self = self else { return }
            self.stopRefreshing()
            
            self.tableView.reloadData()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.stopRefreshing()
            
            self.showError(message: error)
        }
    }
    
    func deleteDocument(vkDoc: VKDocs, row: Int) {
        
        viewModel.deleteDocument(docID: vkDoc.id as! Int, at: row, success: { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.deleteFromTableView(row: row)
            self.tableView.endUpdates()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.showError(message: error)
        }
    }
    
    func editDocument(vkDoc: VKDocs, title: String?, row: Int) {
        guard let title = title else {
            self.showError(message: "Добавьте текст, чтобы редактировать")
            return
        }
        viewModel.editDocument(docID: vkDoc.id as! Int, title: title, at: row, success: { [weak self] in
            guard let self = self else { return }
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
            self.tableView.endUpdates()
        }) { [weak self] (error) in
            guard let self = self else { return }
            self.showError(message: error)
        }
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

//MARK: - DocumentTableViewCellDelegate
extension DocumentsVC: DocumentTableViewCellDelegate {
    func moreButtonTapped(vkDoc: VKDocs, at row: Int) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let restoreBtn = UIAlertAction(title: "Переименовать", style: .default) { [unowned self] (action) in
            self.showEditAlert(vkDoc: vkDoc, row: row)
            sheet.dismiss(animated: true, completion: nil)
        }
        
        sheet.addAction(restoreBtn)
        
        let deleteBtn = UIAlertAction(title: "Удалить документ", style: .destructive) {[unowned self] (action) in
            self.deleteDocument(vkDoc: vkDoc, row: row)
            sheet.dismiss(animated: true, completion: nil)
        }
        
        sheet.addAction(deleteBtn)
        
        let cancelBtn = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
            sheet.dismiss(animated: true, completion: nil)
        }
        sheet.addAction(cancelBtn)
        
        self.present(sheet, animated: true, completion: nil)
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

