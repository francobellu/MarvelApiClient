//
//  RestInterface.swift
//  MarvelApiClient
//
//  Created by franco bellu on 21/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

public struct NetworkCancellableAbstraction{

}

public enum RestServiceErrorAbstraction: Error{

}

public enum RestApiRequestErrorAbstraction: Error{

}

public protocol ResponseRequestableAbstraction{
  associatedtype Response: Decodable
  func extractApiObjectFrom(_ data: Data) -> Result<Response, RestApiRequestErrorAbstraction>
}

public protocol RestServiceAbstraction {
    typealias CompletionHandlerAbstraction<T> = (Result<T, RestServiceErrorAbstraction>) -> Void

  @discardableResult
  func request< Req: ResponseRequestableAbstraction>(with request: Req,
                                        completion: @escaping CompletionHandlerAbstraction<Req.Response>) -> NetworkCancellableAbstraction?
  @discardableResult
  func requestData<Req: ResponseRequestableAbstraction>(with endpoint: Req,
                                         completion: @escaping CompletionHandlerAbstraction<Data>) -> NetworkCancellableAbstraction?
}
