//
//  CharacterDetailInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//  PRESENTER INPUT
protocol GetCharacterInteractorInputPort: class {
  func execute(with id: Int)
}

//  PRESENTER OUTPUT
protocol GetCharacterInteractorOutputPort: class {
  func domainData(result: Result<Character, Error>)
}

private protocol GetCharacterInteractorProtocol: class {
  init(dependencies: AppDIContainerProtocol)
  func handle(result: Result<[CharacterResult], Error>)
}

class GetCharacterInteractor {

  private var dependencies: AppDIContainerProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private let charactersRepository: CharactersRepository

  weak var outputPort: GetCharacterInteractorOutputPort?

  required init(dependencies: AppDIContainerProtocol) {
    self.dependencies = dependencies
    self.charactersRepository = dependencies.factory.makeCharactersRepository()
  }
}

extension GetCharacterInteractor: GetCharacterInteractorInputPort {

  // MARK: - Business logic
  func execute(with id: Int) {
    getCharacter(with: id)
  }
}

// MARK: - PRIVATE functions
private extension GetCharacterInteractor {
  private func getCharacter(with id: Int) {
    //    let request = GetCharacters(restDependencies: dependencies.restDependencies, limit: 20, offset: 0)
    charactersRepository.getCharacter(with: id) { (result) in
      self.handle(result: result)
    }
  }

  private func handle(result: Result<Character, Error>) {
    //    var result: Result<Character, Error>
    //    switch results {
    //    case .success(let character):
    //      result = .success(character)
    //    case .failure(let error):
    //      print(error)
    //      result = .failure(error)
    //    }
    self.outputPort?.domainData(result: result)
  }
}
