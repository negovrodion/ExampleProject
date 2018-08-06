//
//  CurrenciesListViewIO.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - CurrenciesListViewInput
protocol CurrenciesListViewInput: class {
    func setupView()
    func showError(type: CurrenciesListViewError)
    func updateTable()
    func updateValuesExeptFirst(values: [String])
    func updateFirstValue(value: String)
}

// MARK: - CurrenciesListViewOutput
protocol CurrenciesListViewOutput {
    func viewDidLoad()
    func numberOfRowsForTable() -> Int
    func didSelectCell(with indexPath: IndexPath)
    func didChange(value: String)
    func cellFor(indexPath: IndexPath) -> CurrenciesListViewCellModel?
}

