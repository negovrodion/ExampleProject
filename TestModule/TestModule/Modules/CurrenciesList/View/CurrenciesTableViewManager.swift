//
//  CurrenciesTableViewManager.swift
//  TestModule
//
//  Created by Rodion on 30.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CurrenciesTableViewManagerDataProviderProtocol
protocol CurrenciesTableViewManagerDataProviderProtocol {
    var lastSelectedValue: Decimal { get }
    var lastSelectedAbbr: CurrencyAbbr { get }
    var values: Set<CurrenciesListCurrencyPresenterModel> { get }
}

// MARK: - CurrenciesTableViewManagerDelegate
protocol CurrenciesTableViewManagerDelegate: class, CurrenciesTableViewManagerDataProviderProtocol {
    func didChange(value: String)
    func moveToTop(abbr: CurrencyAbbr)
}

// MARK: - CurrenciesTableViewManager
final class CurrenciesTableViewManager: NSObject {
    
    // MARK: - Injections
    weak var delegate: CurrenciesTableViewManagerDelegate?
    weak var tableView: UITableView?
    
    // MARK: - Properties
    fileprivate var indexPathAndAbbrMatching = [CurrencyAbbr]()
    
    // MARK: - Functions
    func update(with models: [CurrenciesListCurrencyPresenterModel]) {
        if indexPathAndAbbrMatching.count != delegate?.values.count {
            indexPathAndAbbrMatching = models.map({ $0.abbr })
            
            tableView?.reloadData()
        } else {
            updateCellsExeptFirst()
        }
    }
    
    // MARK: - Private functions
    fileprivate func updateCellsExeptFirst() {
        let updatedValues = indexPathAndAbbrMatching.compactMap { (currencyAbbr) -> String? in
            guard let lastSelectedAbbr = delegate?.lastSelectedAbbr,
                let lastSelectedValue = delegate?.lastSelectedValue, currencyAbbr != lastSelectedAbbr else {
                return delegate?.lastSelectedValue.toMoneyString
            }
            
            guard let ratio = delegate?.values.filter({ $0.abbr == currencyAbbr }).first?.ratio else {
                return ""
            }
            
            let curVal = ratio * lastSelectedValue
            
            return curVal.toMoneyString
        }
        
        for (item, value) in updatedValues.enumerated() {
            guard item > 0 else { continue }
            
            let indexPath = IndexPath(row: item, section: 0)
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
        return delegate?.values.count ?? 0
    }
    
    // MARK: - Private functions
    private func configureCurrenciesListTableViewCell(cell: CurrenciesListTableViewCell, for indexPath: IndexPath) {
        if let model = currenciesListViewCellModelFor(indexPath: indexPath) {
            cell.configure(with: model, delegate: self)
        }
    }
    
    private func currenciesListViewCellModelFor(indexPath: IndexPath) -> CurrenciesListViewCellModel? {
        guard indexPathAndAbbrMatching.count > indexPath.row,
            let val = delegate?.values.filter({ $0.abbr == indexPathAndAbbrMatching[indexPath.row] }).first,
            let lastSelectedValue = delegate?.lastSelectedValue else { return nil }
        
        let curName = val.abbr.rawValue
        let curVal  = val.ratio * lastSelectedValue
        
        let model = CurrenciesListViewCellModel(curName: curName, value: curVal.toMoneyString)
        
        return model
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
        
        let abbr = indexPathAndAbbrMatching[indexPath.row]
        moveToTop(with: indexPath)
        delegate?.moveToTop(abbr: abbr)
        updateCellsExeptFirst()
        
        guard let lastSelectedValue = delegate?.lastSelectedValue.toMoneyString else { return }
        updateFirstValue(value: lastSelectedValue)
    }
    
    func didChangeValue(cell: UITableViewCell, value: String) {
        delegate?.didChange(value: value)
        
        updateCellsExeptFirst()
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
