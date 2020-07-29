//
//  CharacterDetailPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharacterDetailPresenter {
  private var character = Observable<CharacterResult?>(value: nil)

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var interactor: CharacterDetailInteractorProtocol?

  init(dependencies: AppDependenciesProtocol, character: CharacterResult) {
    self.character.value = character
    self.dependencies = dependencies
  }
  /// Initializer used for deep linking
  init(dependencies: AppDependenciesProtocol, characterId: Int, interactor: CharacterDetailInteractorProtocol) {
    self.dependencies = dependencies
    self.interactor = interactor
    self.getCharacter(with: characterId){
    }
  }

  func getThumbnailUrl() -> URL? {
    return character.value?.thumbnail?.url
  }

  func getName() -> String {
    guard let name = character.value?.name,
              !name.isEmpty  else { return "Character Detail" }
    return name
  }

  func getDescription() -> String {
    guard let description = character.value?.description,
              !description.isEmpty else { return "No Description Available"}
    return description
  }

  func getComicsCount() -> String {
    guard let comicsCount = character.value?.comics?.items?.count,
              comicsCount != 0 else { return "" }
    return "Comics available: \(comicsCount)"
  }

  func getSeriesCount() -> String {
    guard let comicsCount = character.value?.series?.items?.count else { return "" }
    return "Series available: \(comicsCount)"
  }

  func getStoriesCount() -> String {
    guard let comicsCount = character.value?.stories?.items?.count else { return "" }
    return "Stories available: \(comicsCount)"
  }

  // MARK: - Business logic
  func getCharacter(with characterId: Int, completion: @escaping () -> Void) {
    guard let interactor = interactor else { return }
    interactor.getCharacter(with: characterId) { result in
      switch result {
      case .success(let character):
        self.character.value = character
      case .failure: break
      }
      print("FB: character: \(String(describing: self.character))")
      completion()
    }
  }
}
