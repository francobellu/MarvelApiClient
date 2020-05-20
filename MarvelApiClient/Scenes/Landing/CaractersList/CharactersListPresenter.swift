//
//  CharactersListPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharactersListPresenter {

  private weak var coordinatorDelegate: CharactersListCoordinatorDelegate!  //swiftlint:disable:this implicitly_unwrapped_optional

  private var interactor: CharactersListInteractorProtocol

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  private var characters: [CharacterResult] = []


  private(set) var title = "Marvel Comics"

  init(dependencies: AppDependenciesProtocol, coordinatorDelegate: CharactersListCoordinatorDelegate, interactor: CharactersListInteractorProtocol) {
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
    self.interactor = interactor
  }

  func getCharacter(at index: Int) -> CharacterResult {
    return characters[index]

  }

  func charactersCount() -> Int {
    return characters.count
  }

  // MARK: - API FUNCTIONS

  func getNextCharactersList( completion: @escaping () -> Void) {
    interactor.getNextCharactersList { (characters: [CharacterResult]) in
      self.characters += characters
      completion()
    }
  }
}

extension CharactersListPresenter{

  func didSelect(character: CharacterResult) {
    coordinatorDelegate.didSelect(character: character)
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }
}
