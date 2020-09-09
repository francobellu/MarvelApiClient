//
//  CharactersRepositoryTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
import MarvelApiClient
@testable import MarvelApiClient

class CharactersRepositoryTests: XCTestCase {

  let testStoredCharacters: [CharacterResult] = [
    CharacterResult(name: "Stored Character 1", id: 0),
    CharacterResult(name: "Stored Character 2", id: 1)
  ]

  let testApiCharacters: [CharacterResult] = [
    CharacterResult(name: "Api Character 1", id: 2),
    CharacterResult(name: "Api Character 2", id: 3)
  ]

  lazy var testCachedCharactersEntities = testStoredCharacters.map { $0.toDomain() }

  lazy var testApiCharactersEntities = testApiCharacters.map { $0.toDomain() }


  lazy var marvelApiClientMock = MarvelApiClientMock(characters: testApiCharacters)
  lazy var charactersStorageMock = CharactersPersistentStorageMock(characters: testCachedCharactersEntities)
//  lazy var dataStoreMock = DataStoreMock(characters: testStoredCharacters)

  var sut: DefaultCharactersRepository!
//  override func setUpWithError() throws {
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//  }
//
//  override func tearDownWithError() throws {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//  }

  // Get cached characters
  func testGetCharacters_cached_values() throws {
    // Given
    sut = DefaultCharactersRepository(cache: charactersStorageMock, marvelApiClient: marvelApiClientMock)
    var testResult: Result<[Character], Error>!

    // When
    sut.getCharactersList { result in
      testResult = result
    }

    // Then
    let resultCharacters = try! testResult.get()
    XCTAssert(resultCharacters == testCachedCharactersEntities)

  }

  // Get characters from the API ( cahce is empty)
  func testGetCharacters_no_cached_values() throws {
    // Given
    charactersStorageMock = CharactersPersistentStorageMock(characters:  [Character]())
    sut = DefaultCharactersRepository(cache: charactersStorageMock, marvelApiClient: marvelApiClientMock)
    var testResult: Result<[Character], Error>!

    // When
    sut.getCharactersList { result in
      testResult = result
    }

    // Then
    let resultCharacters = try! testResult.get()
    XCTAssert(resultCharacters ==  testApiCharactersEntities)


    // Test that the fertched characters are now present in cache
    var cachedCharacters: [Character]!
    charactersStorageMock.getCharacters(){ characters in
      cachedCharacters = characters
    }
    XCTAssert( cachedCharacters ==  testApiCharactersEntities)
  }
}

class MarvelApiClientMock: MarvelApiProtocol {
  private let characters: [CharacterResult]!

  init(characters: [CharacterResult] ) {
    self.characters = characters
  }
  func getCharactersList(completion: @escaping (Result<[CharacterResult], Error>) -> Void) {
    completion(.success( characters) )
  }

  func getCharacter(with id: Int, completion: @escaping (Result<[CharacterResult], Error>) -> Void) {
    fatalError()
  }
}

class CharactersPersistentStorageMock: CharactersPersistentStorageProtocol {
  private var characters: [Character]

  init(characters: [Character]) {
    self.characters = characters
  }

  func getCharacters(completion: ([Character]) -> Void) {
    completion(characters)
  }

  func save(characters: [Character]) throws {
    self.characters = characters
  }
}
