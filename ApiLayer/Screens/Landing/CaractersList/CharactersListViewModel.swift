//
//  CharactersListViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharactersListViewModel {

  // THE API
  private let apiClient: MarvelAPIProtocol

  var title = "All Characters List..."

  // THE STORAGE
  private var characters: [CharacterResult] = []

  init(dependencies: AppDependencies) {
    self.apiClient = dependencies.marvelApiClient
  }

  func add(characters: [CharacterResult]) {
    return self.characters.append(contentsOf: characters)
  }

  func getCharacter(at index: Int) -> CharacterResult {
    return characters[index]
  }

  func charactersCount() -> Int {
    return characters.count
  }

  // MARK: - API FUNCTIONS
  func getCharactersList(completion: @escaping ( () -> Void) ) {
    apiClient.getCharactersList { ( characters: [CharacterResult])  in
      self.characters = characters
      completion()
    }
  }

  func getNextCharactersList(completion: @escaping () -> Void) {
    apiClient.getNextCharactersList { ( characters: [CharacterResult])  in
      // Update dataSOurce array
      self.characters += characters
      completion()
    }
  }
}
