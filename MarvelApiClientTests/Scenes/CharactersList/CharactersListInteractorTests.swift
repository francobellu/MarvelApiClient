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
  
  override func setUpWithError() throws {

    // CONFIGURE THE MOCK DATA
    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient
//    let testCharacterResultId1009144: [CharacterResult] =
//      getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334")) // TODO: move to presenter Test
//
    let mockCharacters = [CharacterResult]() // TODO create from json??
    let mockDataContainer = DataContainer(offset: 0, limit: 20, total: 1000, count: 0, results: mockCharacters)
    mockApiClient.mockApiClientData.mockCharactersResults = mockDataContainer
    sut = CharactersListInteractor(dependencies: mockAppDependencies)
  }

  // MARK: - Business logic
  func test() throws {

    // TEST initial count is zero - charactersCount(at:)

    sut.getNextCharactersList { characters in
      // TEST characters
      XCTAssertNotNil(characters)
    }
  }
}
