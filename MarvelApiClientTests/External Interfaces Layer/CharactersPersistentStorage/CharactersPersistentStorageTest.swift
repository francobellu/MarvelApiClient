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

  var sut: CharactersCache!

  var testResult: [Character]!

  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
    dataStoreMock = nil
    sut = nil
  }

  func testGetCharacters() throws {
    // Given

    let testEntities = testCharacters.map{$0.toDomain()}
    let testEntitiesData = try testEntities.toData()
    dataStoreMock = DataStoreMock(charactersData: testEntitiesData)
    sut = DefaultCharactersCache(dataStore: dataStoreMock)

    // When
    sut.getCharacters() { characters in
      testResult = characters
    }

    // Then
    XCTAssertEqual(testResult, testEntities)
  }

  func testSaveCharacters() throws {
    // Given
    let dataStoreMock = DataStoreMock(charactersData: Data())
    sut = DefaultCharactersCache(dataStore: dataStoreMock)

    // When
    let entities = testCharacters.map{$0.toDomain()}
    try sut.save(characters: entities)

    sut.getCharacters() { characters in
      testResult = characters
    }

    // Then
    let testEntities = testCharacters.map{$0.toDomain()}
    XCTAssertEqual(testResult, testEntities)
  }
}

class DataStoreMock: DataStore{
  private var charactersData: Data

  init(charactersData: Data) {
    self.charactersData = charactersData
  }
  func getData(_ key: String) -> Data? {
    charactersData
  }

  func setData(key: String, data: Data) {
    charactersData = data
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
