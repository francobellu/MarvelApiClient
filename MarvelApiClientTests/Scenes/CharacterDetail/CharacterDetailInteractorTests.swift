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

  var testCharacterResultId1011334: CharacterResult!

  override func setUpWithError() throws {

    // CONFIGURE THE MOCK DATA
    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient
    let mockCharacters = [CharacterResult]() // TODO create from json??
    let mockDataContainer = DataContainer(offset: 0, limit: 20, total: 1000, count: 0, results: mockCharacters)
    mockApiClient.mockApiClientData.mockCharacterResults = mockDataContainer
  }

  // MARK: - TEST Business logic

  /// TEST  sut creation using init(dependencies: AppDependenciesProtocol, character: CharacterResult)
  func test() throws {
    sut = CharacterDetailInteractor(dependencies: mockAppDependencies)
    sut.getCharacter(with: testCharacterResultId1011334.id!, completion: { character in
      // TEST characters
      XCTAssertNotNil(character)
    })
  }
}
