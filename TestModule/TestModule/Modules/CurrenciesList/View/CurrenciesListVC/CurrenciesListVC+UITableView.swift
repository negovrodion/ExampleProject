//
//  CurrenciesListVC+UITableView.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate
extension CurrenciesListVC: UITableViewDelegate {
    fileprivate enum Constants {
        static let cellHeight = CGFloat(43)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CurrenciesListTableViewCell else { return }
        cell.showKeyboardForCurrencyValue()
    }
}

// MARK: - UITableViewDataSource
extension CurrenciesListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrenciesListTableViewCell.reuseId,
                                                 for: indexPath) as! CurrenciesListTableViewCell
        
        if let model = output.cellFor(indexPath: indexPath) {
            cell.configure(with: model, delegate: self)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.numberOfRowsForTable()
    }
    
}
