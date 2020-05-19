//
//  CharactersListInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharactersListInteractor{

  weak var presenter: CharactersListViewModel?

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelAPIProtocol{
    dependencies.marvelApiClient
  }

  private var characters: [CharacterResult] = []

  init(presenter: CharactersListViewModel, dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
    self.presenter = presenter
  }
  // MARK: - Busines logic

  func getNextCharactersList(completion: @escaping () -> Void) {
    apiClient.getCharactersList { ( characters: [CharacterResult])  in
      // Update dataSource array
      self.characters += characters
      completion()
    }
  }
}
