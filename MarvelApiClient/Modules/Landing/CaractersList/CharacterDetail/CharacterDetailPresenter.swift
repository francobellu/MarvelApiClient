//
//  CharacterDetailPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharacterDetailPresenter {
  private var character: CharacterResult?

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var interactor: CharacterDetailInteractor?

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  init(dependencies: AppDependenciesProtocol, character: CharacterResult) {
    self.character = character
    self.dependencies = dependencies
  }

  /// Initializer used for deep linking
  init(dependencies: AppDependenciesProtocol, characterId: String, interactor: CharacterDetailInteractor) {
    self.dependencies = dependencies
    self.interactor = interactor
  }

  func getThumbnailUrl() -> URL? {
    return character?.thumbnail?.url
  }

  func getName() -> String {
    guard let name = character?.name,
              !name.isEmpty  else { return "Character Detail" }
    return name
  }

  func getDescription() -> String {
    guard let description = character?.description,
              !description.isEmpty else { return "No Description Available"}
    return description
  }

  func getComicsCount() -> String {
    guard let comicsCount = character?.comics?.items?.count,
              comicsCount != 0 else { return "" }
    return "Comics available: \(comicsCount)"
  }

  func getSeriesCount() -> String {
    guard let comicsCount = character?.series?.items?.count else { return "" }
    return "Series available: \(comicsCount)"
  }

  func getStoriesCount() -> String {
    guard let comicsCount = character?.stories?.items?.count else { return "" }
    return "Stories available: \(comicsCount)"
  }

  // MARK: - Business logic
  func getCharacter(with characterId: Int, completion: @escaping () -> Void) {
    guard let interactor = interactor else { return }
    interactor.getCharacter(with: characterId) { character in
      self.character = character
      print("FB: character: \(character)")
      completion()
    }
  }
}
