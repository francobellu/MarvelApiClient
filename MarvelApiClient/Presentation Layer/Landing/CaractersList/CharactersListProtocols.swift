//
//  CharactersListProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

// ViewController <-- Presenter
protocol DataBinding: class {
  var viewDidLoadChanged: ((Bool) -> Void)? { get set }
  var titleChanged: ((String) -> Void)? { get set }
  var presentationModelChanged: (([CharacterCellPresentationModel]) -> Void)? { get set }
  var isLoadingChanged: (( Bool) -> Void)? {get set}
  var isErrorChanged: (( Error?) -> Void)? {get set}
}

// Presenter
protocol CharactersListPresenterProtocol: class {

  // ViewController <-- Presenter When these data change a correspondent data binding funcion is called
  var viewDidLoad: Observable<Bool> { get set}
  var presentationModel: Observable<[CharacterCellPresentationModel]> { get set}
  var title: Observable<String> { get set}
  var isLoading: Observable<Bool> {get set }
  var isError: Observable<Error?> {get set }

  // ViewController --> Presenter
  func didSelectCharacter(at: Int)
  func didGoBack()

  //  Presenter --> Interactor
  func getNextCharactersList()
}
