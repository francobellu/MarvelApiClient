//
//  CharactersListProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 03/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol CharactersListPresenterProtocol: class {

  var cellViewModels: Observable<[CharacterCellViewModel]>  { get set}
  var title: Observable<String> { get set}
  var isLoading: Observable<Bool> {get set }

  // View life cycle
  func viewDidLoad()

  // loca data getters
  func charactersCount() -> Int

  // Async calls
  func getNextCharactersList()

  // User Interaction
  func didSelectCharacter(at: Int)
  func didGoBack()
}
