//
//  CharactersListPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharactersListPresenter: CharactersListPresenterProtocol {
  // Observables
  var title = Observable<String>(value: "Marvel Comics")
  var cellViewModels =  Observable<[CharacterCellViewModel]>(value: [])
  var isLoading = Observable<Bool>(value: false)

  weak var viewControllerDelegate: CharactersListPresenterToViewProtocol?

  func viewDidLoad() {
    viewControllerDelegate?.prepareView()
    getNextCharactersList()
  }

  private weak var coordinatorDelegate: CharactersListCoordinatorDelegate!  //swiftlint:disable:this implicitly_unwrapped_optional

  private var interactor: CharactersListInteractorProtocol

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  init(dependencies: AppDependenciesProtocol, coordinatorDelegate: CharactersListCoordinatorDelegate, interactor: CharactersListInteractorProtocol) {
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
    self.interactor = interactor
  }

  private func getCharacter(at index: Int) -> CharacterResult {
    let viewModel = cellViewModels.value[index]
    return CharacterResult(name: viewModel.title, imageUrl: viewModel.imgViewUrl)
  }

  func charactersCount() -> Int {
    return cellViewModels.value.count
  }

  // MARK: - API FUNCTIONS
  func getNextCharactersList() {
    isLoading.value = true
    interactor.getNextCharactersList { [weak self] (characters: [CharacterResult]) in
//      self?.characters += characters
      self?.isLoading.value = false
      self?.buildViewModels(characters: characters)
    }
  }

  /// Arrange the sections/row view model and caregorize by date
  func buildViewModels(characters: [CharacterResult]) {
    var cellViewModels = [CharacterCellViewModel]()
    for character in characters {
      let characterCellViewModel: CharacterCellViewModel = CharacterCellViewModel(character: character)
      cellViewModels.append(characterCellViewModel)
    }
    self.cellViewModels.value += cellViewModels
  }
}

// MARK: - FLOW CharactersListCoordinatorDelegate
extension CharactersListPresenter{
  func didSelectCharacter(at index: Int) {
    let viewModel = cellViewModels.value[index]
    let character = CharacterResult(name: viewModel.title, imageUrl: viewModel.imgViewUrl)
    coordinatorDelegate.didSelect(character: character)
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }
}
