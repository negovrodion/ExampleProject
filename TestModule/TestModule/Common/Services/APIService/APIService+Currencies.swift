//
//  APIService+Currencies.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Alamofire

// MARK: - CurrenciesListAPIServiceProtocol
extension APIService: CurrenciesListAPIServiceProtocol {

    func loadCurrencies(base: CurrencyAbbr,
                        complition: @escaping ((APIService.RequestResult<[CurrencyParsedModel]>)) -> ()) {
        let path       = Paths.Currencies.latest + "?base=" + base.rawValue
        let parameters = NetworkService.RequestParameters()
        
        networkService.send(path: path, parameters: parameters) { [parseService] (result) in
            switch result {
            case .success(let json):
                guard let parsedModels = parseService.parseLatestCurrencies(withBase: base, data: json) else {
                    complition(.fail(.couldNotParse))
                  
                    return
                }
                
                complition(.success(parsedModels))
            case .fail( _):
                complition(.fail(.serverError))
            }
        }
    }
    
}
