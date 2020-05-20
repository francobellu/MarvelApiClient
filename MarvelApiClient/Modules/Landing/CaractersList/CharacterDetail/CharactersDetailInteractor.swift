//
//  CharacterDetailInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharacterDetailInteractor {

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelAPIProtocol{
    dependencies.marvelApiClient
  }

  private var character: CharacterResult?

  init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }

  // MARK: - Business logic
  func getCharacter(with characterId: Int, completion: @escaping (CharacterResult) -> Void) {

    apiClient.getCharacter(with: characterId) { response in
      switch response {
      case .success(let dataContainer):
        guard let character = dataContainer.results.first else { return  }
        completion(character)
      case .failure(let error):
        print(error)
      }
    }
  }
}
