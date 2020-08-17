//
//  CharacterDetailPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharacterDetailPresenter {
  private var character = Observable<Character?>(value: nil)

  private var dependencies: AppDIContainerProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var interactor: GetCharacterInteractorInputPort?

  init(dependencies: AppDIContainerProtocol, character: Character) {
    self.character.value = character
    self.dependencies = dependencies
  }
  /// Initializer used for deep linking
  init(dependencies: AppDIContainerProtocol, id: Int, interactor: GetCharacterInteractorInputPort) {
    self.dependencies = dependencies
    self.interactor = interactor
    self.getCharacter(with: id){
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
    guard let comicsCount = character.value?.comics,
              comicsCount != 0 else { return "" }
    return "Comics available: \(comicsCount)"
  }

  func getSeriesCount() -> String {
    guard let comicsCount = character.value?.series else { return "" }
    return "Series available: \(comicsCount)"
  }

  func getStoriesCount() -> String {
    guard let comicsCount = character.value?.stories else { return "" }
    return "Stories available: \(comicsCount)"
  }

  // MARK: - Domain Layer calls
  func getCharacter(with id: Int, completion: @escaping () -> Void) {
    guard let interactor = interactor else { return }
    interactor.execute(with: id)
  }
}

// MARK: - GetCharactersListInteractorOutputPort
extension CharacterDetailPresenter: GetCharacterInteractorOutputPort{
  func domainData(result: Result<Character, Error>) {
    switch result {
    case .success(let character):
      self.character.value = character
//      self.isLoading.value = false
//      self.buildPresentationModel(from: characters)
    case .failure(let error):
      print(error)
//      self.isError.value = error
      // Hanlde Errors
    }
  }
}
