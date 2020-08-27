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

  // Presentation Model Observables
  var viewDidLoad = Observable<Bool>(value: false)
  var title = Observable<String>(value: "Marvel Characters")
  var presentationModel =  Observable<[CharacterCellPresentationModel]>(value: [])
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
    let cellPresentationModel = presentationModel.value[index]
    let character = Character(name: cellPresentationModel.title, imageUrl: cellPresentationModel.imgViewUrl)
    coordinatorDelegate.didSelect(character: character)
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }

  /// Arrange the sections/row view model and caregorize by date
  private func buildPresentationModel(from characters: [Character]) {
    var cellPresentationModels = [CharacterCellPresentationModel]()
    for character in characters {
      let characterCellViewModel: CharacterCellPresentationModel = CharacterCellPresentationModel(character: character)
      cellPresentationModels.append(characterCellViewModel)
    }
    self.presentationModel.value += cellPresentationModels
  }
}

// MARK: - GetCharactersListInteractorOutputPort
extension CharactersListPresenter: GetCharactersListInteractorOutputPort {
  func domainData(result: Result<[Character], Error>) {
    switch result {
    case .success(let characters):
      self.buildPresentationModel(from: characters)
    case .failure(let error):
      let uiError = MarvelApiClientUiErrorBuilder.uiErrorFrom(error: error as NSError)
      self.isError.value = uiError
      didGoBack()
    }
    self.isLoading.value = false
  }
}

func buildPresentationModels(from characters: [Character]) -> [CharacterCellPresentationModel] {
  var cellPresentationModels = [CharacterCellPresentationModel]()
  for character in characters {
    let characterCellViewModel: CharacterCellPresentationModel = CharacterCellPresentationModel(character: character)
    cellPresentationModels.append(characterCellViewModel)
  }
  return cellPresentationModels
}
