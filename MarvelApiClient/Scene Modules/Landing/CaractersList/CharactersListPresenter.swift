//
//  CharactersListPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharactersListPresenter: CharactersListPresenterProtocol {
  private weak var coordinatorDelegate: CharactersListCoordinatorDelegate!  //swiftlint:disable:this implicitly_unwrapped_optional

  private var interactor: GetCharactersListInteractorInputPort

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  // Presentation Model Observables
  var viewDidLoad = Observable<Bool>(value: false)
  var title = Observable<String>(value: "Marvel Comics")
  var cellPresentationModels =  Observable<[CharacterCellPresentationModel]>(value: [])
  var isLoading = Observable<Bool>(value: false)

  init(dependencies: AppDependenciesProtocol, coordinatorDelegate: CharactersListCoordinatorDelegate, interactor: GetCharactersListInteractorInputPort) {
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
    self.interactor = interactor
  }

  func charactersCount() -> Int {
    return cellPresentationModels.value.count
  }

  // MARK: - API FUNCTIONS
  func getNextCharactersList() {
    isLoading.value = true
    interactor.execute()
  }

  /// Arrange the sections/row view model and caregorize by date
  func buildViewModels(from characters: [CharacterResult]) {
    var cellPresentationModels = [CharacterCellPresentationModel]()
    for character in characters {
      let characterCellViewModel: CharacterCellPresentationModel = CharacterCellPresentationModel(character: character)
      cellPresentationModels.append(characterCellViewModel)
    }
    self.cellPresentationModels.value += cellPresentationModels
  }
}

// MARK: - FLOW CharactersListCoordinatorDelegate
extension CharactersListPresenter{
  func didSelectCharacter(at index: Int) {
    let presentationModel = cellPresentationModels.value[index]
    let character = CharacterResult(name: presentationModel.title, imageUrl: presentationModel.imgViewUrl)
    coordinatorDelegate.didSelect(character: character)
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }
}

// MARK: - GetCharactersListInteractorOutputPort
extension CharactersListPresenter: GetCharactersListInteractorOutputPort{
  func domainData(result: Result<DataContainer<GetCharacters.Response>, Error>) {
    switch result {
    case .success(let dataContainer):
      self.isLoading.value = false
      self.buildViewModels(from: dataContainer.results)
    case .failure(let error):
      print(error)
      // Hanlde Errors
    }
  }
}
