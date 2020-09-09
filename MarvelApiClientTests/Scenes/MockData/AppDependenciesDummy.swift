//
//  AppDependenciesDummy.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest
@testable import MarvelApiClient

class DataStoreDummy: DataStoreProtocol {
  func getData(_ key: String) -> Data? {
    nil
  }

  func getString(_ key: String, defaultValue: String) -> String {
    ""
  }

  func getBool(_ key: String, defaultValue: Bool) -> Bool {
    false
  }

  func setData(key: String, data: Data) {
  }

  func setString(key: String, value: String) {

  }

  func setBool(key: String, value: Bool) {

  }
}

class AppDependenciesDummy: AppDIContainer {
  let charactersRepositoryMock: CharactersRepositoryMock
  init(restDependencies: RestDependenciesProtocol, charactersRepositoryMock: CharactersRepositoryMock) {
    self.charactersRepositoryMock = charactersRepositoryMock
    super.init()
  }
}

//  lazy var factory: Factory = Factory(dependencies: self)
//
//  func makeCharacterDetailView(character: CharacterResult) -> CharacterDetailViewController {
//
//  }
//
//  func makeCharacterDetailView(with characterId: String) -> CharacterDetailViewController {
//
//  }
//
//  func makeCharactersView(coordinatorDelegate: CharactersListCoordinatorDelegate) -> CharactersListViewController {
//    
//  }
//
//  // MARK: - All the app dependencies
//
//  let mockData: String = ""
//
//
//  lazy var  restDependencies: RestDependenciesProtocol = {
//    return RestDependencies()
//  }()
//
//  lazy var defaultttpService: DefaultHttpService = {
//    return DefaultHttpService(session: MockURLSession())
//  }()
//
//  lazy var marvelApiClient: MarvelApiProtocol = {
//    return MockApiClient()
//  }()
//
//  lazy var dataStore: DataStoreProtocol = {
//    UserDefaultsDataStore()
//  }()
//
//  lazy var appSettings: AppSettings = {
//    AppSettings(dataStore: DataStoreDummy())
//  }()
//}
