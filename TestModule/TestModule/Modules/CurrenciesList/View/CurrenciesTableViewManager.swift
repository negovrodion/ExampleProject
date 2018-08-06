//
//  CurrenciesTableViewManager.swift
//  TestModule
//
//  Created by Rodion on 30.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CurrenciesTableViewManager
final class CurrenciesTableViewManager: NSObject {
    
    // MARK: - Injections
    weak var output: CurrenciesListViewOutput!
    weak var tableView: UITableView?
    
    // MARK: - Properties
    fileprivate var indexPathAndAbbrMatching = [CurrenciesListViewCellModel]()
    
    // MARK: - Functions
    func update(with models: [CurrenciesListViewCellModel]) {
        if indexPathAndAbbrMatching.count != models.count {
            indexPathAndAbbrMatching = models
            
            tableView?.reloadData()
        } else {
            updateCellsExeptFirst(models: models)
        }
    }
    
    // MARK: - Private functions
    fileprivate func updateCellsExeptFirst(models: [CurrenciesListViewCellModel]) {
        var updatedValues = [String]()
        for (item, model) in indexPathAndAbbrMatching.enumerated() {
            guard item != 0, item < models.count else { continue }
            
            let value = models.filter({ $0.abbr == model.abbr }).first?.value ?? ""
            indexPathAndAbbrMatching[item].value = value
            
            updatedValues.append(value)
        }
        
        for (item, value) in updatedValues.enumerated() {
            let indexPath = IndexPath(row: item + 1, section: 0)
            guard let cell = tableView?.cellForRow(at: indexPath) as? CurrenciesListTableViewCell else { continue }
            
            cell.updateCurrencyValue(with: value)
        }
    }
}

// MARK: - UITableViewDelegate
extension CurrenciesTableViewManager: UITableViewDelegate {
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
extension CurrenciesTableViewManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrenciesListTableViewCell.reuseId,
                                                 for: indexPath) as! CurrenciesListTableViewCell
        
        configureCurrenciesListTableViewCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexPathAndAbbrMatching.count
    }
    
    // MARK: - Private functions
    private func configureCurrenciesListTableViewCell(cell: CurrenciesListTableViewCell, for indexPath: IndexPath) {
        guard indexPath.row < indexPathAndAbbrMatching.count else {
            return
        }
        
        let model = indexPathAndAbbrMatching[indexPath.row]
        
        cell.configure(with: model, delegate: self)
    }
}

// MARK: - CurrenciesListTableViewCellDelegate
extension CurrenciesTableViewManager: CurrenciesListTableViewCellDelegate {
    
    func didBecomeFirstResponder(cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell), indexPathAndAbbrMatching.count > indexPath.row else {
            return
        }

        let topIndexPath = IndexPath(row: 0, section: 0)
        tableView?.moveRow(at: indexPath, to: topIndexPath)

        let abbr = indexPathAndAbbrMatching[indexPath.row].abbr
        moveToTop(with: indexPath)
        output.didSelectCell(with: abbr)
    }

    func didChangeValue(cell: UITableViewCell, value: String) {
        output.didChange(value: value)
    }
    
    // MARK: - Private functions
    private func moveToTop(with: IndexPath) {
        guard indexPathAndAbbrMatching.count > with.row, with.row > 0 else { return }
        let topModel = indexPathAndAbbrMatching[with.row]
        
        for i in (1...with.row).reversed() {
            indexPathAndAbbrMatching[i] = indexPathAndAbbrMatching[i - 1]
        }
        
        indexPathAndAbbrMatching[0] = topModel
    }
    
    private func updateFirstValue(value: String) {
        let indexPath = IndexPath(row: 0, section: 0)
        guard let cell = tableView?.cellForRow(at: indexPath) as? CurrenciesListTableViewCell else { return }
        
        cell.updateCurrencyValue(with: value)
    }
    
}
