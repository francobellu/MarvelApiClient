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

  func getName() -> String {
    return character?.name ?? "character Detail"
  }

  func getComicsCount() -> String {
    guard let comicsCount = character?.comics?.items?.count else { return "0" }
    return "Comics available: \(comicsCount)"
  }

  func getSeriesCount() -> String {
    guard let comicsCount = character?.series?.items?.count else { return "0" }
    return "Series available: \(comicsCount)"
  }

  func getStoriesCount() -> String {
    guard let comicsCount = character?.stories?.items?.count else { return "0" }
    return "Stories available: \(comicsCount)"
  }
}
