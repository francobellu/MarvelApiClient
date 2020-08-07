//
//  DependencyContainer.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit


protocol AppDependenciesProtocol: class {

//  var restDependencies: RestDependenciesProtocol { get }

  var marvelApiClient: MarvelApiProtocol { get }

  var dataStore: DataStoreProtocol { get }

  var appConfig: AppConfig { get }

  // ViewCobntrollers Factory
  var factory: Factory { get }

  func makeCharactersRepository() -> CharactersRepository

}

/// Encapsulate all the app dependencies and act as a factory for them
class AppDependencies: AppDependenciesProtocol {


  // MARK: - All the app dependencies

  var marvelApiClient: MarvelApiProtocol

  var charactersRepository: CharactersRepository

//  var restDependencies: RestDependenciesProtocol

  var dataStore: DataStoreProtocol

  lazy var appConfig: AppConfig = AppConfig(dataStore: self.dataStore)
//  lazy var appConfiguration = AppConfiguration()

  lazy var factory: Factory = Factory(dependencies: self)

  init(restDependencies: RestDependenciesProtocol, dataStore: DataStoreProtocol = UserDefaultsDataStore()) {
//    self.restDependencies = restDependencies
    self.dataStore = dataStore
    self.marvelApiClient = MarvelApiClient(restDependencies: restDependencies)
    self.charactersRepository = DefaultCharactersRepository(apiClient: self.marvelApiClient)
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

// MARK: -
extension AppDependencies{
  // MARK: - Use Cases
  func makeCharactersRepository() -> CharactersRepository {
    return DefaultCharactersRepository(apiClient: marvelApiClient)
  }

//  // MARK: - Repositories
//  func makeCharactersInteractor() -> CharactersInteractor {
//      return DefaultMoviesRepository(dataTransferService: dependencies.apiDataTransferService, cache: moviesResponseCache)
//  }
}
