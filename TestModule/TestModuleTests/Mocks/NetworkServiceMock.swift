//
//  NetworkServiceMock.swift
//  TestModuleTests
//
//  Created by Rodion on 27.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

@testable import TestModule
import Foundation
import Alamofire

// MARK: - NetworkServiceMock
final class NetworkServiceMock {
    
    // MARK: - Setting
    enum Setting {
        case success(Any)
        case fail(Any)
    }
    
    // MARK: - Properties
    private let setting: Setting
    
    // MARK: - Initialization
    init(setting: Setting) {
        self.setting = setting
    }
}

// MARK: - NetworkServiceProtocol
extension NetworkServiceMock: NetworkServiceProtocol {
    func send(path: String, parameters: NetworkService.RequestParameters,
              callback: @escaping ((NetworkService.RequestResult) -> ())) {
        send(fullpath: path, parameters: parameters, callback: callback)
    }
    
    func send(fullpath: String, parameters: NetworkService.RequestParameters,
              callback: @escaping ((NetworkService.RequestResult) -> ())) {
        switch setting {
        case .success(let data):
            callback(.success(data))
        case .fail(let error):
            callback(.fail(error))
        }
    }
}
