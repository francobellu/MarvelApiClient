//
//  CharacterDetailViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharacterDetailViewModel {
  var character: CharacterResult! // swiftlint:disable:this implicitly_unwrapped_optional
  var characterId: String! // swiftlint:disable:this implicitly_unwrapped_optional

  init(dependencies: AppDependencies, character: CharacterResult) {
    self.character = character
  }

  init(dependencies: AppDependencies, characterId: String) {
    self.characterId = characterId
  }

  func getName() -> String {
    return character?.name ?? "character Detail"
  }

  func getDescription() -> String {
    guard let description = character.description,
              !description.isEmpty else { return "No Description Available"}
    return description
  }

  func getComicsCount() -> String {
    guard let comicsCount = character.comics?.items?.count,
              comicsCount != 0 else { return "" }
    return "Comics available: \(comicsCount)"
  }

  func getSeriesCount() -> String {
    guard let comicsCount = character.series?.items?.count else { return "" }
    return "Series available: \(comicsCount)"
  }

  func getStoriesCount() -> String {
    guard let comicsCount = character.stories?.items?.count else { return "" }
    return "Stories available: \(comicsCount)"
  }
}
