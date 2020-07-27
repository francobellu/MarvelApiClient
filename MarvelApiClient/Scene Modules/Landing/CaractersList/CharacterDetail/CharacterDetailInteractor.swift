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
  func getCharacter(with characterId: Int, completion: @escaping (CharacterResult?) -> Void)
}

class CharacterDetailInteractor: CharacterDetailInteractorProtocol{

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  required init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }

  // MARK: - Business logic
  func getCharacter(with characterId: Int, completion: @escaping (CharacterResult?) -> Void) {
    apiClient.getCharacter(with: characterId) { response in
      switch response {
      case .success(let characters):
        completion(characters.first)
      case .failure(let error):
        completion( nil )
        print(error)
      }
    }
  }
}
