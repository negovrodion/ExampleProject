//
//  CurrenciesListVC.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit
import SwiftyDrop

// MARK: - CurrenciesListVC
final class CurrenciesListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Injections
    var output: CurrenciesListViewOutput!
    var tableViewManager = CurrenciesTableViewManager()
    
    // MARK: - Lify cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewManager.output    = output
        tableViewManager.tableView = tableView
        
        output.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private functions
    private func setup() {
        tableView.dataSource = tableViewManager
        tableView.delegate   = tableViewManager
        
        tableView.register(UINib(nibName: CurrenciesListTableViewCell.reuseId, bundle: Bundle.main),
                           forCellReuseIdentifier: CurrenciesListTableViewCell.reuseId)
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.size.height, right: 0)
        
        tableView.contentInset          = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        tableView.contentInset          = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

// MARK: - CurrenciesListViewInput
extension CurrenciesListVC: CurrenciesListViewInput {
    func showError(type: CurrenciesListViewError) {
        switch type {
        case .canNotUpdate:
            Drop.down(String.Strings.canNotUpdate)
        case .dataInconsistency:
            Drop.down(String.Strings.canNotUpdate)
        }
    }
    
    func updateTable(with models: [CurrenciesListViewCellModel]) {
        tableViewManager.update(with: models)
    }
    
    func setupView() {
        setup()
    }
}
//
//// MARK: - CurrenciesTableViewManagerDelegate
//extension CurrenciesListVC: CurrenciesTableViewManagerDelegate {
 
//    func moveToTop(abbr: CurrencyAbbr) {
//        output.didSelectCell(with: abbr)
//    }
//}
