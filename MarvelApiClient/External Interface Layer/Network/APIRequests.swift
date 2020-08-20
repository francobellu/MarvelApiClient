//
//  APIRequests.swift
//  MarvelApiClient
//
//  Created by franco bellu on 17/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest
struct APIRequests {
  static func getCharactersList() -> MarvelApiRequest<[CharacterResult]>{
    let query = CharactersQuery(name: nil, nameStartsWith: nil, limit: 50, offset: 0)
    do {
      return try MarvelApiRequest<[CharacterResult]>( resourceName:"characters",
                                                          method: .get,
                                                          urlParameters: query.toDictionaryOfString())
    } catch {
      //      completion(.failure(RequestGenerationError.components))
      fatalError()
    }
  }

  static func getCharacter(with id: Int) -> MarvelApiRequest <[CharacterResult]>{

    do {
      return try  MarvelApiRequest(resourceName:"characters",
                                       method: .get,
                                       urlParameters: ["id": String(id)])
    } catch {
      //      completion(.failure(RequestGenerationError.components))
    }
  }
}

class GetCharactersListReq: MarvelApiRequest<[CharacterResult]>{
//  let resourceName: String
//  let method: RestMethod
//  let urlParameters: [String: String]?

   init(query: CharactersQuery) {
    super.init(resourceName: "characters", method: .get, urlParameters: try? query.toDictionaryOfString())
  }
}
