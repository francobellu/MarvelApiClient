//
//  CharactersPersistentStorageTest.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 08/09/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest

@testable import MarvelApiClient

class CharactersPersistentStorageTest: XCTestCase {

  let testCharacters: [CharacterResult] = getDtos(from: "MockedResponseGetCharacters")

  var dataStoreMock: DataStoreMock!

  var sut: CharactersPersistentStorage!

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
    dataStoreMock = nil
    sut = nil
  }

  func testGetCharacters() throws {
    // Given
    dataStoreMock = DataStoreMock(charactersMock: testCharacters)
    sut = CharactersPersistentStorage(dataStore: dataStoreMock)

    var testResult: [CharacterResult]!

    // When
    sut.getCharacters() { characters in
      testResult = characters
    }

    // Then
    XCTAssertEqual(testResult, testCharacters)
  }

  func testSaveCharacters() throws {
    // Given
    let dataStoreMock = DataStoreMock(charactersMock: [CharacterResult]())
    sut = CharactersPersistentStorage(dataStore: dataStoreMock)

    // When
    sut.save(characters: testCharacters)

    sut.getCharacters() { characters in
      testResult = characters
    }

    // Then
    XCTAssertEqual(testResult, testCharacters)
  }
}

class DataStoreMock: DataStoreProtocol{
  private var characters: [CharacterResult]

  init(charactersMock: [CharacterResult]) {
    characters = charactersMock
  }
  func getAny(_ key: String) -> Any? {
    characters
  }

  func setAny(key: String, value: Any) {
    characters = value as! [CharacterResult]
  }

  func getString(_ key: String, defaultValue: String) -> String {
    fatalError()
  }

  func getBool(_ key: String, defaultValue: Bool) -> Bool {
    fatalError()
  }

  func setString(key: String, value: String) {
    fatalError()
  }

  func setBool(key: String, value: Bool) {
    fatalError()
  }


}
