//
//  CharactersListProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

// Presenter --> View
protocol DataBinding: class{
  var viewDidLoadChanged: ((Bool) -> Void)? { get set }
  var titleChanged: ((String) -> Void)? { get set }
  var presentationModelChanged: (([CharacterCellPresentationModel]) -> Void)? { get set }
  var isLoadingChanged: (( Bool) -> Void)? {get set}
  var isErrorChanged: (( Error?) -> Void)? {get set}
}

// Presenter
protocol CharactersListPresenterProtocol: class {

  // ViewController <--> Presenter
  var viewDidLoad: Observable<Bool>  { get set}
  var presentationModel: Observable<[CharacterCellPresentationModel]>  { get set}
  var title: Observable<String> { get set}
  var isLoading: Observable<Bool> {get set }
  var isError: Observable<Error?> {get set }

  func didSelectCharacter(at: Int)

  func didGoBack()
  func getNextCharactersList()
}

//// Presenter --> Interactor
//protocol GetCharactersListInteractorProtocol {
//  init(dependencies: AppDependenciesProtocol)
//  func execute(completion: @escaping ([CharacterResult]) -> Void)
//}

protocol CharactersRepository {
//    @discardableResult
    func getCharactersList( //query: MovieQuery, page: Int,
//                         cached: @escaping (MoviesPage) -> Void,
                         completion: @escaping (Result<CharacterResult, Error>) -> Void)// -> Cancellable?
}
