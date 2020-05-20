//
//  CharactersListInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol CharactersListInteractorProtocol {
  init(dependencies: AppDependenciesProtocol)
  func getNextCharactersList(completion: @escaping ([CharacterResult]) -> Void)
}

class CharactersListInteractor: CharactersListInteractorProtocol {

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  required init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }

  // MARK: - Business logic
  func getNextCharactersList(completion: @escaping ([CharacterResult]) -> Void) {
    apiClient.getCharactersList { response in

      switch response {
      case .success(let dataContainer):
        completion(dataContainer.results)
      case .failure(let error):
        print(error)
        completion([CharacterResult]())
      }
    }
  }
}
