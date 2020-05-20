//
//  DependencyContainer.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

protocol AppDependenciesProtocol: class {
  var httpClient: HttpClient { get }

  var marvelApiClient: MarvelAPIProtocol { get }

  var dataStore: DataStoreProtocol { get }

  var appConfig: AppConfig { get }
}

/// Encapsulate all the app dependencies and act as a factory for them
class AppDependencies: AppDependenciesProtocol {
  // MARK: - All the app dependencies

  lazy var httpClient: HttpClient = {
    return HttpClient()
  }()

  lazy var marvelApiClient: MarvelAPIProtocol = {
    MarvelAPIClient(httpClient: HttpClient())
  }()

  lazy var dataStore: DataStoreProtocol = {
    UserDefaultsDataStore()
  }()

  lazy var appConfig: AppConfig = {
    AppConfig()
  }()

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
