//
//  CharactersCache.swift
//  MarvelApiClient
//
//  Created by franco bellu on 08/09/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

// Gets cached characters from a dataStoreProtocol implementatiopn
final class DefaultCharactersCache: CharactersCache{

  let dataStore: DataStore

  init(dataStore: DataStore = UserDefaultsDataStore()) {
    self.dataStore = dataStore
  }

  func getCharacters( completion: ([Character]) -> Void ){
    // get the data
    var result = [Character]()
    let charactersData = dataStore.getData(UserDefaultKeys.characters)
    if let non_nil_charactersData = charactersData {
      let decoder = JSONDecoder()
      if let characters = try? decoder.decode([Character].self, from: non_nil_charactersData) {
        print(characters)
        result = characters
      }
    }
    completion(result)
  }

  func save( characters: [Character]) throws{
    let charactersData = try characters.toData()
    dataStore.setData(key: UserDefaultKeys.characters, data: charactersData)
  }
}
