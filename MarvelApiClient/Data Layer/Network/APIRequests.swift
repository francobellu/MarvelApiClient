//
//  APIRequests.swift
//  MarvelApiClient
//
//  Created by franco bellu on 17/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

struct APIRequests {
  static func getCharactersList() -> MarvelApiRequestImpl<[CharacterResult]>{
    let query = CharactersQuery(name: nil, nameStartsWith: nil, limit: 50, offset: 0)
    do {
      return try MarvelApiRequestImpl<[CharacterResult]>( resourceName:"characters",
                                                          method: .get,
                                                          urlParameters: query.toDictionaryOfString())
    } catch {
      //      completion(.failure(RequestGenerationError.components))
      fatalError()
    }
  }

  static func getCharacter(with id: Int) -> MarvelApiRequestImpl <[CharacterResult]>{

    do {
      return try  MarvelApiRequestImpl(resourceName:"characters",
                                       method: .get,
                                       urlParameters: ["id": String(id)])
    } catch {
      //      completion(.failure(RequestGenerationError.components))
    }
  }
}
