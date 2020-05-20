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

  var sut: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  
  override func setUpWithError() throws {
    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient

    let testCharacterResultId1009144: [CharacterResult] =  getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))
    mockApiClient.mockApiClientData.mockCharactersData = testCharacterResultId1009144
    sut = CharactersListPresenter(dependencies: mockAppDependencies, coordinatorDelegate: mockCoordinator)
  }

  // MARK: - TEST API FUNCTIONS
  func test() throws {

    // TEST initial count is zero - charactersCount(at:)
    XCTAssert(sut.charactersCount() == 0 )

    // TEST getNextCharactersList(at:)
    sut.getNextCharactersList {
      // TEST count now is > zero - charactersCount()
      let charactercount = self.sut.charactersCount()
      XCTAssert(charactercount > 0 )

      // TEST character at index 0 has expected id - getCharacter(at:)
      let character = self.sut.getCharacter(at: 0)
      let characterIdAt0 = 1011334
      XCTAssert(character.id == characterIdAt0)

      XCTAssert(self.mockCoordinator.coordinatorState == .none)
      self.sut.didGoBack()
      self.mockCoordinator.coordinatorState = .didSelect(character: character)
    }
  }
}
