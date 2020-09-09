//
//  UserDefaultsDataStoreTest.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 09/09/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient

class UserDefaultsDataStoreTest: XCTestCase {

  var sut: UserDefaultsDataStore = UserDefaultsDataStore()

  func testSetAny() throws {
    // Given
    let testCharacters = [
      Character(name: "a", imageUrl: nil),
      Character(name: "B", imageUrl: nil)
    ]
    let testCharactersData: Data = try testCharacters.toData()
    let decoder = JSONDecoder()

    // When
    sut.setData(key: UserDefaultKeys.characters, data: testCharactersData)

    let resultCharactersData: Data = sut.getData(UserDefaultKeys.characters)!

    // Then
    let resultCharacters = try! decoder.decode([Character].self, from: resultCharactersData)
    print(resultCharacters)
    XCTAssertEqual(resultCharacters, testCharacters)
  }
}
