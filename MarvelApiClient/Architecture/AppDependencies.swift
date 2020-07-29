//
//  DependencyContainer.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit
import Rest


// TODO: what to do with this protocol?
//public protocol RestApiClientProtocol {
//  init(session: URLSessionProtocol)
//  func send<T: RestAPIRequest>(_ request: T, completion: @escaping URLRequestResultCompletion)
//  func cancel()
//}

extension RestApiClient: RestApiClientProtocol {}


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

class RestDependencies: RestDependenciesProtocol{

  var restApiClient: RestApiClientProtocol = RestApiClient()

  var apiRequestConfig: RestServiceConfigProtocol = MarvelApiRequestConfig()

  var method: RestMethod = .get

}

protocol AppDependenciesProtocol: class {

  var restDependencies: RestDependenciesProtocol { get }

//  var marvelApiClient: MarvelApiProtocol { get }

  var dataStore: DataStoreProtocol { get }

  var appConfig: AppConfig { get }

  // Factory functions
  func makeCharacterDetailView(character: CharacterResult) -> CharacterDetailViewController

}

/// Encapsulate all the app dependencies and act as a factory for them
class AppDependencies: AppDependenciesProtocol {

  // MARK: - All the app dependencies

  var restDependencies: RestDependenciesProtocol = RestDependencies()

  //  lazy var marvelApiClient: MarvelApiProtocol = {
  //    MarvelApiClient(restApiClient: RestApiClient())
  //  }()

  lazy var dataStore: DataStoreProtocol = {
    UserDefaultsDataStore()
  }()

  lazy var appConfig: AppConfig = {
    AppConfig(dataStore: self.dataStore)
  }()

  // When only property dependency injection is possible like for ViewControllers
  func inject(into object: AnyObject) {
    if let dependencyInjectable = object as? AppDependencyInjectable {
      dependencyInjectable.dependencies = self
    }
  }

  func makeCharacterDetailView(character: CharacterResult) -> CharacterDetailViewController{
    let viewPresenter = CharacterDetailPresenter(dependencies: self, character: character)
    let view  = CharacterDetailViewController.instantiateViewController()
    view.presenter = viewPresenter
    return view
  }
}

protocol AppDependencyInjectable: class {
  var dependencies: AppDependenciesProtocol! { get set } // swiftlint:disable:this implicitly_unwrapped_optional
}
