//
//  CharactersListProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

// Presenter --> ViewController
protocol CharactersListPresenterToViewProtocol: class{
  func prepareView()
}

// Presenter --> ViewController
protocol CharactersListPresenterProtocol: class {
  var viewDidLoad: Observable<Bool>  { get set}
  var cellViewModels: Observable<[CharacterCellViewModel]>  { get set}
  var title: Observable<String> { get set}
  var isLoading: Observable<Bool> {get set }

  // Data source data
//  func charactersCount() -> Int

  // Async calls
  func getNextCharactersList()

  // User Interaction
  func didSelectCharacter(at: Int)
  func didGoBack()
}

// Presenter --> Interactor
protocol CharactersListInteractorProtocol {
  init(dependencies: AppDependenciesProtocol)
  func getNextCharactersList(completion: @escaping ([CharacterResult]) -> Void)
}
