//
//  CharactersListPresenterTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

import XCTest
@testable import MarvelApiClient

class CharactersListPresenterTest: XCTestCase {
  var sut: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  var mockIterator: MockCharactersListInteractor!

  override func setUpWithError() throws {
    mockIterator =  MockCharactersListInteractor(dependencies: mockAppDependencies)
  }

  func test() throws {

    // CONFIGURE THE MOCK DATA
    let testResults: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
    let testResult = testResults.first!
    mockIterator.mockCharactersListInteractorData.mockCharactersResults = testResults
    sut = CharactersListPresenter(dependencies: mockAppDependencies,
                                  coordinatorDelegate: mockCoordinator,
                                  interactor: mockIterator!)


    // TEST initial count is zero - charactersCount(at:)
    XCTAssert(sut.charactersCount() == 0 )

    // TEST getNextCharactersList(at:)
    sut.getNextCharactersList {
      // TEST count now is > zero - charactersCount()
      let charactersCount = self.sut.charactersCount()
      XCTAssert(charactersCount > 0 )

      // TEST character at index 0 has expected id - getCharacter(at:)
     let character = self.sut.getCharacter(at: 0)
      XCTAssert(character.id == testResult.id)

      XCTAssert(self.mockCoordinator.coordinatorState == .none)
      self.sut.didGoBack()
      self.mockCoordinator.coordinatorState = .didSelect(character: character)
    }
  }
}
