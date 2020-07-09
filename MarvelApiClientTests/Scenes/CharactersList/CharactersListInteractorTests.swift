//
//  CharactersListInteractorTest.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient


class CharactersListInteractorTest: XCTestCase {

  var sut: CharactersListInteractor! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  var mockApiClient: MockApiClient!
  
  override func setUpWithError() throws {
    mockApiClient = mockAppDependencies.marvelApiClient as? MockApiClient
    sut = CharactersListInteractor(dependencies: mockAppDependencies)
  }

  // MARK: - Business logic
  func testSuccess() throws {

    // CONFIGURE THE MOCK DATA WITH AN ARRAY OF EMPTY CharacterResult
    let testCharacters: [CharacterResult] = fetch(from: "MockedResponseGetCharacters")
    let testDataContainer = DataContainer(offset: 0, limit: 20, total: 1000, count: 0, results: testCharacters)
    mockApiClient.mockApiClientData.mockCharactersResults = testDataContainer

    sut.getNextCharactersList { characters in
     // TEST characters
      XCTAssertNotNil(characters)
      XCTAssertNotNil(characters.count == testCharacters.count)
    }
  }

  func testFailure() throws {

    // CONFIGURE THE MOCK DATA WITH EMPTY ARRAY
    let testCharacters: [CharacterResult] = []
    let mockDataContainer = DataContainer(offset: 0, limit: 20, total: 1000, count: 0, results: testCharacters)
    mockApiClient.mockApiClientData.mockCharactersResults = mockDataContainer

    sut.getNextCharactersList { characters in
      // TEST characters
      XCTAssert(characters.isEmpty)
    }
  }
}
