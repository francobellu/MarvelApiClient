//
//  CharactersListViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharactersListViewModel {

  private weak var coordinatorDelegate: CharactersListCoordinatorDelegate!  //swiftlint:disable:this implicitly_unwrapped_optional

  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelAPIProtocol{
    dependencies.marvelApiClient
  }

  private var characters: [CharacterResult] = []

  private(set) var title = "Marvel Comics"

  init(dependencies: AppDependencies, coordinatorDelegate: CharactersListCoordinatorDelegate) {
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
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

  func getNextCharactersList(completion: @escaping () -> Void) {
    apiClient.getCharactersList { ( characters: [CharacterResult])  in
      // Update dataSOurce array
      self.characters += characters
      completion()
    }
  }
}

extension CharactersListViewModel{

  func didSelect(character: CharacterResult) {
    coordinatorDelegate.didSelect(character: character)
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }

}
