//
//  CharactersListProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//// Presenter --> ViewController
//protocol CharactersListPresenterToViewProtocol: class{
//  var viewDidLoad: ((Bool) -> Void)? { get set }
//  var changedTitle: ((String) -> Void)? { get set }
//  var cellPresentationModels: (([CharacterCellPresentationModel]) -> Void)? { get set }
//  var isLoading: ((Bool) -> Void)? { get set }
//  
//  func prepareView()
//}

// Presenter
protocol CharactersListPresenterProtocol: class {

  // ViewController <--> Presenter
  var viewDidLoad: Observable<Bool>  { get set}
  var cellPresentationModels: Observable<[CharacterCellPresentationModel]>  { get set}
  var title: Observable<String> { get set}
  var isLoading: Observable<Bool> {get set }

  // ViewController --> Presenter  TODO: should ViewController call directly the coord?
  func didSelectCharacter(at: Int)
  func didGoBack()

  // Data source data
//  func charactersCount() -> Int

  // Presenter --> Interactor
  func getNextCharactersList()

  // Presenter <-- Interactor

  // User Interaction

}

// Presenter --> Interactor
protocol GetCharactersListInteractorProtocol {
  init(dependencies: AppDependenciesProtocol)
  func execute(completion: @escaping ([CharacterResult]) -> Void)
}
