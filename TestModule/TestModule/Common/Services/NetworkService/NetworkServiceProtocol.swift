//
//  NetworkServiceProtocol.swift
//  TestModule
//
//  Created by Rodion Negov on 7/11/18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Alamofire


// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    /// Send request to server.
    /// - parameter path: Path to endpoint not including server URL.
    /// - parameter parameters: Set of parameters for request.
    /// - parameter callback: Callback with result or error description.
    func send(path: String, parameters: NetworkService.RequestParameters,
              callback: @escaping ((NetworkService.RequestResult) -> ()))
    
    /// Send request to server.
    /// - parameter fullpath: Full path to endpoint including server URL.
    /// - parameter parameters: Set of parameters for request.
    /// - parameter callback: Callback with result or error description.
    func send(fullpath: String, parameters: NetworkService.RequestParameters,
              callback: @escaping ((NetworkService.RequestResult) -> ()))
    
}
