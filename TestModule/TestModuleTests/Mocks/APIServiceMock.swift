//
//  APIServiceMock.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

@testable import TestModule

import Foundation

// MARK: - APIServiceMock
final class APIServiceMock {
    // MARK: - Properties
    fileprivate let data: [CurrencyParsedModel]?
    
    // MARK: - Initialization
    init(data: [CurrencyParsedModel]?) {
        self.data = data
    }
}

// MARK: - CurrenciesListAPIServiceProtocol
extension APIServiceMock: CurrenciesListAPIServiceProtocol {
    func loadCurrencies(base: CurrencyAbbr,
                        complition: @escaping ((APIService.RequestResult<[CurrencyParsedModel]>)) -> ()) {
        guard let models = data else {
            complition(.fail(.serverError))
            
            return
        }
        
        complition(.success(models))
    }
    
}
