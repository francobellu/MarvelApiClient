//
//  CharacterDetailInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol CharacterDetailInteractorProtocol {
  init(dependencies: AppDependenciesProtocol)

  // MARK: - Business logic
   func getCharacter(with characterId: Int, completion: @escaping (Result<CharacterResult, Error>) -> Void)
}

class CharacterDetailInteractor: CharacterDetailInteractorProtocol{

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

//  private var apiClient: MarvelApiProtocol{
//    dependencies.marvelApiClient
//  }

  required init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }

  // MARK: - Business logic
  func getCharacter(with characterId: Int, completion: @escaping (Result<CharacterResult, Error>) -> Void) {

    let request = GetCharacter(restDependencies: dependencies.restDependencies, id: characterId)
    request.execute { result in
      print("\nGetCharacter \(characterId) finished")

      var completionResult: Result<CharacterResult, Error>
      switch result {
      case .success(let characters):
        guard let character = characters.first else{
          completionResult = .failure(MarvelError.noData)
          return
        }
        completionResult = .success(character)
      case .failure(let error):
        completionResult = .failure(error)
      }
      completion(completionResult)
    }
  }
}
