//
//  APIService.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Foundation

// MARK: - APIService
final class APIService {
    
    // MARK: - RequestResult
    enum RequestResult<T> {
        case success(T)
        case fail(Error)
        
        // MARK: - Error
        enum Error {
            case serverError
            case couldNotParse
        }
    }
    
    // MARK: - Paths
    enum Paths {
        
        enum Currencies {
            static let latest = "latest"
        }
    }
    
    // MARK: - Injections
    var networkService: NetworkServiceProtocol
    var parseService: ParseServiceProtocol
    
    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol, parseService: ParseServiceProtocol) {
        self.networkService = networkService
        self.parseService   = parseService
    }
    
}
