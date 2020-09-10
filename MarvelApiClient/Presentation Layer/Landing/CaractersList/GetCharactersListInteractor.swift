//
//  GetCharactersListInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//  PRESENTER INPUT
protocol GetCharactersListInteractorInputPort: class {
  func execute()
}

//  PRESENTER OUTPUT
protocol GetCharactersListInteractorOutputPort: class {
  func domainData(result: Result<[Character], Error>)
}

class GetCharactersListInteractor {
  private let charactersRepository: CharactersRepository

  weak var outputPort: GetCharactersListInteractorOutputPort?

  required init(charactersRepository: CharactersRepository) {
    self.charactersRepository = charactersRepository
  }

  private func getCharactersList() {
    //    let request = GetCharacters(restDependencies: dependencies.restDependencies, limit: 20, offset: 0)
    charactersRepository.getCharactersList { (result) in
      self.handle(result: result)
    }
  }

  fileprivate func handle(result: Result<[Character], Error>) {
    self.outputPort?.domainData(result: result)
  }
}

extension GetCharactersListInteractor: GetCharactersListInteractorInputPort {

  // MARK: - Business logic
  func execute() {
    getCharactersList()
  }
}

// MARK: - PRIVATE functions
private extension GetCharactersListInteractor {

}
