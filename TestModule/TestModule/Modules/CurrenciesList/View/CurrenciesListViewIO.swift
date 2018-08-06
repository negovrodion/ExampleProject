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
    func updateTable(with models: [CurrenciesListCurrencyPresenterModel])
}

// MARK: - CurrenciesListViewOutput
protocol CurrenciesListViewOutput: CurrenciesTableViewManagerDataProviderProtocol {
    func viewDidLoad()
    func didSelectCell(with abbr: CurrencyAbbr)
    func didChange(value: String)
}

