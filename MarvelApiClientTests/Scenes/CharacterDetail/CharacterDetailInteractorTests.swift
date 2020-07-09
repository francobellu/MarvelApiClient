//
//  PresentationLayer.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient


class CharacterDetailInteractorTest: XCTestCase {
  var sut: CharacterDetailInteractor! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  var mockApiClient: MockApiClient!

  override func setUpWithError() throws {
    mockApiClient = mockAppDependencies.marvelApiClient as? MockApiClient
    sut = CharacterDetailInteractor(dependencies: mockAppDependencies)
  }

  // MARK: - TEST Business logic

  /// TEST  sut creation using init(dependencies: AppDependenciesProtocol, character: CharacterResult)
  func testSuccess() throws {

    // CONFIGURE THE MOCK DATA
    let testCharacters: [CharacterResult] = fetch(from: "MockedResponseGetCharacters")
    let testDataContainer = DataContainer(offset: 0, limit: 20, total: 1000, count: 0, results: testCharacters)
    mockApiClient.mockApiClientData.mockCharacterResults = testDataContainer

    let testCharacter = testCharacters.first!
    sut.getCharacter(with: testCharacter.id!, completion: { characterResult in
      // TEST characters
      XCTAssertNotNil(characterResult)
      XCTAssertNotNil(characterResult?.id == testCharacter.id)
    })
  }

  func testFailure() throws {

    // CONFIGURE THE MOCK DATA WITH NIL
    mockApiClient.mockApiClientData.mockCharacterResults = nil

    let testCharacterId = 0
    sut.getCharacter(with: testCharacterId, completion: { characterResult in
      // TEST characters
      XCTAssertNil(characterResult)
    })
  }
}
