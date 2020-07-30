//
//  RestDependencies.swift
//  MarvelApiClient
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

extension RestApiClient: RestApiClientProtocol {}

// TODO: what to do with this protocol?
//public protocol RestApiClientProtocol {
//  init(session: URLSessionProtocol)
//  func send<T: RestAPIRequest>(_ request: T, completion: @escaping URLRequestResultCompletion)
//  func cancel()
//}

protocol RestDependenciesProtocol{
  var restApiClient: RestApiClientProtocol { get set}

  var apiRequestConfig: RestServiceConfigProtocol { get set}

  var method: RestMethod { get set}
}

protocol RestAPIRequestDependenciesProtocol {

  /// Response (will be wrapped with a DataContainer)
  associatedtype Response: Decodable

  /// Service data needed to construct the endpoint url
  var apiRequestConfig: RestServiceConfigProtocol { get set}

  /// Resource name needed to construct the endpoint url
  var resourceName: String { get }

  var method: RestMethod { get }

  var parameters: [String: String]? { get }

  ///  Decodes the  response data  stripping all the wrappers.  In the process  all the possible errors are handled
  /// - Parameters:
  ///   - data: The data as returned by the Service
  /// - Returns: A Result encasulating the Response object requested by the request or an Error
  func decode(_ data: Data) -> Result<Response, Error>

}

protocol AppDependenciesProtocol: class {

  var restDependencies: RestDependenciesProtocol { get }

  //  var marvelApiClient: MarvelApiProtocol { get }

  var dataStore: DataStoreProtocol { get }

  var appConfig: AppConfig { get }

  // ViewCobntrollers Factory
  var factory: Factory { get }

}

class RestDependencies: RestDependenciesProtocol{

  var restApiClient: RestApiClientProtocol = RestApiClient()

  var apiRequestConfig: RestServiceConfigProtocol = MarvelApiRequestConfig()

  var method: RestMethod = .get

}
