//
//  DefaultCharactersRepository.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation


final class DefaultCharactersRepository {

  private let apiClient: MarvelApiProtocol

  init(apiClient: MarvelApiProtocol) {
    self.apiClient = apiClient
  }
}

extension DefaultCharactersRepository: CharactersRepository {
  func getCharactersList(completion: @escaping (Result<[Character], Error>) -> Void) {

//    let requestDTO = CharactersRequestDTO(query: query)
    let endpoint = apiClient.getCharactersList { result in
      switch result {
      case .success(let responseDTO):
//        self.cache.save(response: responseDTO, for: requestDTO)
        let characterResults = (responseDTO as [CharacterResult] )
        let charactersEntities = characterResults.map{ $0.toDomain()}
        completion(.success(charactersEntities)) // responseDTO.toDomain()
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
