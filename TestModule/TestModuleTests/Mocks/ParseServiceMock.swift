//
//  ParseServiceMock.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

@testable import TestModule
import Foundation

// MARK: - ParseServiceMock
final class ParseServiceMock {
    // MARK: - Setting
    enum Setting {
        case success
        case fail
    }
    
    // MARK: - Properties
    private let setting: Setting
    private let data: [CurrencyParsedModel]
    
    // MARK: - Initialization
    init(setting: Setting, data: [CurrencyParsedModel] = [CurrencyParsedModel]()) {
        self.setting = setting
        self.data    = data
    }
}

// MARK: - ParseServiceProtocol
extension ParseServiceMock: ParseServiceProtocol {
    func parseLatestCurrencies(withBase: CurrencyAbbr, data: Any) -> [CurrencyParsedModel]? {
        switch setting {
        case .success:
            return self.data
        case .fail:
            return nil
        }
    }

}
