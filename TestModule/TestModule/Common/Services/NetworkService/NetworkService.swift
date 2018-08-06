//
//  NetworkService.swift
//  TestModule
//
//  Created by Rodion Negov on 7/11/18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import Alamofire

// MARK: - NetworkService
final class NetworkService {
    
    // MARK: - RequestParameters
    struct RequestParameters {
        
        /// Request method GET/POST.
        var method: HTTPMethod
        
        /// Dictionary of headers in [ String : String ] format.
        var headers: HTTPHeaders?
        
        /// Dictionary of parameters in [ String : String ] format.
        var parameters: Parameters?
        
        /// How encode parameters for request.
        var encoding: ParameterEncoding
        
        // MARK: - Initialization
        init(method: HTTPMethod = .get, headers: HTTPHeaders? = nil, parameters: Parameters? = nil,
             encoding: ParameterEncoding = JSONEncoding.default) {
            self.method     = method
            self.headers    = headers
            self.parameters = parameters
            self.encoding   = encoding
        }
    }
    
    // MARK: - RequestResult
    enum RequestResult {
        case success(Any)
        case fail(Any)
    }
    
    // MARK: - Constants
    fileprivate enum Constants {
        static let ServerUrl = Config.shared.endpointsServerURL
    }
    
    // MARK: - Functions
    static func request(url: URLConvertible, parameters: RequestParameters) -> DataRequest {
        return Alamofire.request(url, method: parameters.method, parameters: parameters.parameters,
                                 encoding: parameters.encoding, headers: parameters.headers)
    }
    
}

// MARK: - NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
    func send(path: String, parameters: RequestParameters,
              callback: @escaping ((NetworkService.RequestResult) -> ())) {
        let url = Constants.ServerUrl + path
        
        send(fullpath: url, parameters: parameters, callback: callback)
    }
    
    func send(fullpath: String, parameters: RequestParameters,
              callback: @escaping ((NetworkService.RequestResult) -> ())) {
        
        NetworkService.request(url: fullpath, parameters: parameters).validate()
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let json):
                    callback(.success(json))
                case .failure(let error):
                    callback(.fail(error))
                }
            })
    }
}
