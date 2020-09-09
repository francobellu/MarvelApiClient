//
//  CharactersPersistentStorage.swift
//  MarvelApiClient
//
//  Created by franco bellu on 08/09/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

// TODO: move to UserDefaultsDataStore
struct UserDefaultKeys{
  static let characters = "Characters"
}

protocol CharactersPersistentStorageProtocol{

  func getCharacters( completion: ([CharacterResult]) -> Void )

  func save( characters: [CharacterResult])
}

// Gets cached characters from a dataStoreProtocol implementatiopn
class CharactersPersistentStorage: CharactersPersistentStorageProtocol{

  let dataStore: DataStoreProtocol

  init(dataStore: DataStoreProtocol = UserDefaultsDataStore()) {
    self.dataStore = dataStore
  }
  func getCharacters( completion: ([CharacterResult]) -> Void ){
    // get the data
    var result = [CharacterResult]()
    let characters = dataStore.getAny(UserDefaultKeys.characters) as? [CharacterResult]
    if let non_nil_characters = characters {
      result = non_nil_characters
    }
    completion(result)
  }

  func save( characters: [CharacterResult]){
    // set the data
    dataStore.setAny(key: UserDefaultKeys.characters, value: characters)
  }
}
