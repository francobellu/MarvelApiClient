//
//  AppDependenciesDummy.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
@testable import MarvelApiClient

class DataStoreDummy: DataStoreProtocol{
  func getAny(_ key: String) -> Any? {
    nil
  }

  func getString(_ key: String, defaultValue: String) -> String {
    ""
  }

  func getBool(_ key: String, defaultValue: Bool) -> Bool {
    false
  }

  func setAny(key: String, value: Any) {
  }

  func setString(key: String, value: String) {

  }

  func setBool(key: String, value: Bool) {

  }
}

class AppDependenciesDummy: AppDependenciesProtocol {
  func makeCharacterDetailView(character: CharacterResult) -> CharacterDetailViewController {
    <#code#>
  }

  func makeCharacterDetailView(with characterId: String) -> CharacterDetailViewController {
    <#code#>
  }

  func makeCharactersView(coordinatorDelegate: CharactersListCoordinatorDelegate) -> CharactersListViewController {
    <#code#>
  }

  // MARK: - All the app dependencies

  let mockData: String = ""


  lazy var  restDependencies: RestDependenciesProtocol = {
    return RestDependencies()
  }()

  lazy var restApiClient: RestApiClient = {
    return RestApiClient(session: MockURLSession())
  }()

  lazy var marvelApiClient: MarvelApiProtocol = {
    return MockApiClient()
  }()

  lazy var dataStore: DataStoreProtocol = {
    UserDefaultsDataStore()
  }()

  lazy var appConfig: AppConfig = {
    AppConfig(dataStore: DataStoreDummy())
  }()
}
