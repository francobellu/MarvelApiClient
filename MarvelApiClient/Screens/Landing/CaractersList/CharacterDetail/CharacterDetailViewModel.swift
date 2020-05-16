//
//  CharacterDetailViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharacterDetailViewModel {

  private(set) var title = "Character Detail"

  // THE STORAGE
  var character: CharacterResult?
  var characterId: String?

  init(dependencies: AppDependencies, character: CharacterResult) {
    self.character = character
  }

  init(dependencies: AppDependencies, characterId: String) {
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
