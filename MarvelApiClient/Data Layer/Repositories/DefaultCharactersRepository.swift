//
//  DefaultCharactersRepository.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

final class DefaultCharactersRepository {

  private let marvelApiClient: MarvelApiProtocol
  private let cache: CharactersPersistentStorageProtocol

  init(cache: CharactersPersistentStorageProtocol,
       marvelApiClient: MarvelApiProtocol ) {
    self.marvelApiClient = marvelApiClient
    self.cache = cache
  }
}

extension DefaultCharactersRepository: CharactersRepository {
  private func cache(_ charactersEntities: [Character], completion: @escaping (Result<[Character], Error>) -> Void) {
    do {
      try self.cache.save(characters: charactersEntities)
    } catch  {
      completion(.success(charactersEntities))
      // TODO, handle error
      // throw error
    }
  }

  func getCharactersList(completion: @escaping (Result<[Character], Error>) -> Void) {
    cache.getCharacters { (characters) in
      if !characters.isEmpty{
        completion(.success(characters))
      } else{
        //    let requestDTO =  marvelApiClientMock(query: query)
        marvelApiClient.getCharactersList { result in // TODO: not returning an Endpoint
          switch result {
          case .success(let responseDTO):
            let characterResults = (responseDTO as [CharacterResult] )
            let charactersEntities = characterResults.map { $0.toDomain()}
            self.cache(charactersEntities, completion: completion)
            completion(.success(charactersEntities))
          case .failure(let error):
            completion(.failure(error))
          }
        }
      }
    }
  }

  func getCharacter(with id: Int, completion: @escaping (Result<Character, Error>) -> Void) {

    //    let requestDTO = CharactersRequestDTO(query: query)
    marvelApiClient.getCharacter(with: id) { result in // TODO: not returning an Endpoint
      switch result {
      case .success(let responseDTO):
        //        self.cache.save(response: responseDTO, for: requestDTO)
        let characterResults = (responseDTO as [CharacterResult] )
        guard let characterDto = characterResults.first else { return }
        let character = characterDto.toDomain()
        completion(.success(character))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
