//
//  CharactersListPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

let charactersListTitle = "Marvel Characters"

class CharactersListPresenter: CharactersListPresenterProtocol {
  private weak var coordinatorDelegate: CharactersListCoordinatorDelegate!  //swiftlint:disable:this implicitly_unwrapped_optional

  private var interactor: GetCharactersListInteractorInputPort

  private var dependencies: AppDIContainerProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var characters = [Character]()
  // Presentation Model Observables
  var viewDidLoad = Observable<Bool>(value: false)
  var title = Observable<String>(value: "Marvel Characters")
  var presentationModel = Observable<[CharacterCellPresentationModel]>(value: [])
  var isLoading = Observable<Bool>(value: false)
  var isError = Observable<Error?>(value: nil)

  init(dependencies: AppDIContainerProtocol, coordinatorDelegate: CharactersListCoordinatorDelegate, interactor: GetCharactersListInteractorInputPort) {
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
    self.interactor = interactor
  }

  // MARK: - Domain Layer calls
  func getNextCharactersList() {
    isLoading.value = true
    interactor.execute()
  }

  // MARK: - FLOW CharactersListCoordinatorDelegate
  func didSelectCharacter(at index: Int) {
    coordinatorDelegate.didSelect(character: characters[index])
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }

//
//  private func presentationModel(from characters: [Character]) -> [CharacterCellPresentationModel] {
//    var cellPresentationModels = [CharacterCellPresentationModel]()
//    for character in characters {
//      let characterCellViewModel: CharacterCellPresentationModel = CharacterCellPresentationModel(character: character)
//      cellPresentationModels.append(characterCellViewModel)
//    }
//    return cellPresentationModels
//  }

  static func presentationModel(from characters: [Character]) -> [CharacterCellPresentationModel] {
    var cellPresentationModels = [CharacterCellPresentationModel]()
    for character in characters {
      let characterCellViewModel: CharacterCellPresentationModel = CharacterCellPresentationModel(character: character)
      cellPresentationModels.append(characterCellViewModel)
    }
    return cellPresentationModels
  }
}

// MARK: - GetCharactersListInteractorOutputPort
extension CharactersListPresenter: GetCharactersListInteractorOutputPort {
  func domainData(result: Result<[Character], Error>) {
    switch result {
    case .success(let characters):
      self.characters = characters
      let newCellPresentationModels = CharactersListPresenter.presentationModel(from: characters)
      self.presentationModel.value += newCellPresentationModels
    case .failure(let error):
      let uiError = MarvelApiClientUiErrorBuilder.uiErrorFrom(error: error as NSError)
      self.isError.value = uiError
    }
    self.isLoading.value = false
  }
}
