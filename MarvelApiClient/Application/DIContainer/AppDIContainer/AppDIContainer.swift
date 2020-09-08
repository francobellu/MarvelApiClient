//
//  DependencyContainer.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

// This protocol can be used to derive a test container to use mock services
protocol AppDIContainerProtocol: class {

  // External module dependency
  var restDependencies: RestDependenciesProtocol { get }

  // Used by the AppSettings and other services
  var dataStore: DataStoreProtocol { get }

  // Used to store Settings
  var appSettings: AppSettings { get }

  // Components Factory
  var factory: Factory { get }

}

/// Encapsulate all the app dependencies and act as a factory for them
class AppDIContainer: AppDIContainerProtocol {

  // MARK: - All the app dependencies
  lazy var restDependencies: RestDependenciesProtocol = RestDependencies(marvelApiConfig: marvelApiConfig)

  var dataStore: DataStoreProtocol

  lazy var appSettings: AppSettings = AppSettings(dataStore: self.dataStore)

  lazy var factory: Factory = Factory(dependencies: self)

  let marvelApiConfig = MarvelApiRequestConfig()

  init(dataStore: DataStoreProtocol = UserDefaultsDataStore()) {
    self.dataStore = dataStore
  }

  // When only property dependency injection is possible like for ViewControllers
  func inject(into object: AnyObject) {
    if let dependencyInjectable = object as? AppDependencyInjectable {
      dependencyInjectable.dependencies = self
    }
  }
}

protocol AppDependencyInjectable: class {
  var dependencies: AppDIContainerProtocol! { get set } // swiftlint:disable:this implicitly_unwrapped_optional
}
