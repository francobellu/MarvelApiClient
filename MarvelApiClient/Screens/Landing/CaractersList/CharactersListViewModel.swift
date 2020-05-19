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

  var interactor: CharactersListInteractor?

  private(set) var title = "Marvel Comics"

  init(coordinatorDelegate: CharactersListCoordinatorDelegate) {
    self.coordinatorDelegate = coordinatorDelegate
  }

  func getCharacter(at index: Int) -> CharacterResult {
    return interactor.
  }

  func charactersCount() -> Int {
    return characters.count
  }

  // MARK: - API FUNCTIONS

  func getNextCharactersList() {
    interactor?.getNextCharactersList{
      
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
