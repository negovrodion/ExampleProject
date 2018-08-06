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
    
    // MARK: - Lify cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.register(UINib(nibName: CurrenciesListTableViewCell.reuseId, bundle: Bundle.main),
                           forCellReuseIdentifier: CurrenciesListTableViewCell.reuseId)
        
    }
    
    func moveCellToTop(indexPath: IndexPath) {
        let topIndexPath = IndexPath(row: 0, section: 0)
        
        tableView.moveRow(at: indexPath, to: topIndexPath)
        
        output.didSelectCell(with: indexPath)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.size.width, right: 0)
        
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
        }
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func updateValuesExeptFirst(values: [String]) {
        for (item, value) in values.enumerated() {
            guard item > 0 else { continue }
            
            let indexPath = IndexPath(row: item, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? CurrenciesListTableViewCell else { continue }
            
            cell.updateCurrencyValue(with: value)
        }
    }
    
    func setupView() {
        setup()
    }
    
    func updateFirstValue(value: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? CurrenciesListTableViewCell else { return }
        
        cell.updateCurrencyValue(with: value)
    }
}

// MARK: - CurrenciesListTableViewCellDelegate
extension CurrenciesListVC: CurrenciesListTableViewCellDelegate {
    func didBecomeFirstResponder(cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        
        moveCellToTop(indexPath: indexPath)
    }
    
    func didChangeValue(cell: UITableViewCell, value: String) {
        output.didChange(value: value)
    }
    
}
