//
//  CharacterDetailViewModel.swift
//  
//
//  Created by BELLU Franco on 06/11/2018.
//

import Foundation

class CharacterDetailViewModel: AppDependencyInjectable {
  var dependencies: AppDependencies!
  // THE API
  private var title = "Character Detail"

  // THE STORAGE
  var character: CharacterResult?
  var characterId: String?

  init(dependencies: AppDependencies, character: CharacterResult) {
    self.dependencies = dependencies
    self.character = character
  }

  init(dependencies: AppDependencies, characterId: String) {
    self.dependencies = dependencies
    self.characterId = characterId
  }

  // MARK: - API FUNCTIONS

//  private func getCharacter(for id: Int)  {
//    dependencies.marvelApiClient.getCharactersList { ( character: ComicCharacter)  in
//      self.character = character
//      completion()
//    }
//  }
}
