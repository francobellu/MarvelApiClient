//
//  DependencyContainer.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

struct MarvelApiRequestConfig: RestServiceConfigProtocol {

  var publicKey: String? = "e7416283f4f02fb5ca8b883e421fa857"
  var privateKey: String? = "b687a3d1c855db14f30638c2530e8ceb1dc93b0f"

  let baseEndpointString = "https://gateway.marvel.com:443/v1/public/"
  var baseEndpointUrl: URL? {
    guard let url = URL(string: baseEndpointString) else {return nil}
    return url
  }

  // Encodes a URL based on the given request using
  // Create a URLComponents url composing:
  // 1) baseUrl = baseEndpointUrl +  request.resourceName
  // 2) commonQueryItems ( marvel-specific params)
  // 3) customQueryItems ( request-specific params)
  func buildEndpointUrlFor(resourceName: String, parameters: [String: String]? = nil) -> URL? {
    // Build baseUrl = baseEndpointUrl +  request.resourceName
    guard let baseUrl = URL(string: resourceName, relativeTo: URL(string: baseEndpointString) ) else {
      return URL(string: baseEndpointString)
    }
    guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }

    // Build common query items needed for all Marvel requests
    guard let commonQueryItems = try? buildCommonQueryItems() else{ return nil }

    // Build customQueryItems ( request-specific params)
    let customQueryItems = buildCustomQueryItems(parameters)

    components.queryItems = commonQueryItems + customQueryItems

    return components.url
  }

  // Build commonQueryItems ( marvel-specific params)
  private func buildCommonQueryItems() throws-> [URLQueryItem]{
    var result = [URLQueryItem]()
    if let privateKey = privateKey, let publicKey = publicKey{
      let timestamp = "\(Date().timeIntervalSince1970)"

      let str = "\(timestamp)\(privateKey)\(publicKey)"

      guard let digest =  str.insecureMD5Hash() else { throw MarvelError.encoding }
      result = [
        URLQueryItem(name: "ts", value: timestamp),
        URLQueryItem(name: "hash", value: digest),
        URLQueryItem(name: "apikey", value: publicKey)
      ]
    }
    return result
  }

  // Build customQueryItems ( request-specific params)
  private func buildCustomQueryItems(_ parameters: [String: String]?) -> [URLQueryItem]{
    var result = [URLQueryItem]()
    if let params = parameters, !params.isEmpty {
      result = params.map { item, value in
        URLQueryItem(name: item, value: value)
      }
    }
    return result
  }
}


protocol AppDependenciesProtocol: class {

//  var restDependencies: RestDependenciesProtocol { get }

  var marvelApiClient: MarvelApiProtocol { get }

  var dataStore: DataStoreProtocol { get }

  var appConfig: AppConfig { get }

  // ViewCobntrollers Factory
  var factory: Factory { get }

}

/// Encapsulate all the app dependencies and act as a factory for them
class AppDependencies: AppDependenciesProtocol {


  // MARK: - All the app dependencies

  var marvelApiClient: MarvelApiProtocol

//  var restDependencies: RestDependenciesProtocol

  var dataStore: DataStoreProtocol

  lazy var appConfig: AppConfig = AppConfig(dataStore: self.dataStore)
//  lazy var appConfiguration = AppConfiguration()

  lazy var factory: Factory = Factory(dependencies: self)

  init(restDependencies: RestDependenciesProtocol, dataStore: DataStoreProtocol = UserDefaultsDataStore()) {
//    self.restDependencies = restDependencies
    self.dataStore = dataStore
    self.marvelApiClient = MarvelApiClient(restDependencies: restDependencies)
  }

  // When only property dependency injection is possible like for ViewControllers
  func inject(into object: AnyObject) {
    if let dependencyInjectable = object as? AppDependencyInjectable {
      dependencyInjectable.dependencies = self
    }
  }
}

protocol AppDependencyInjectable: class {
  var dependencies: AppDependenciesProtocol! { get set } // swiftlint:disable:this implicitly_unwrapped_optional
}
