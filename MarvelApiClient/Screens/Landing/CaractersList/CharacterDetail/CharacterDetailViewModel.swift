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

  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelAPIProtocol{
    dependencies.marvelApiClient
  }

  init(dependencies: AppDependencies, character: CharacterResult) {
    self.character = character
  }

  /// Initializer used for deep linking
  init(dependencies: AppDependencies, characterId: String) {
    self.dependencies = dependencies
  }

  // MARK: - API FUNCTIONS
  func getCharacter(with characterId: Int, completion: @escaping () -> Void) {
    apiClient.getCharacter(with: characterId) { character in
      self.character = character
      print("FB: character: \(character)")
      completion()
    }
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
