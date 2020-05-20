//
//  CharactersListPresenterTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//
//  PresentationLayer.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient

class MockCharactersListInteractor: CharactersListInteractorProtocol{
  required init(dependencies: AppDependenciesProtocol) {
    //    TODO:
  }

  func getNextCharactersList(completion: @escaping ([CharacterResult]) -> Void) {

  }
}

class CharactersListPresenterTest: XCTestCase {

  var sut: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  var mockCharactersListInteractor: MockCharactersListInteractor? = nil
  var testCharacterResultId1009144: [CharacterResult]? = nil

  override func setUpWithError() throws {
//    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient

    mockCharactersListInteractor =  MockCharactersListInteractor(dependencies: mockAppDependencies)

//    mockApiClient.mockApiClientData.mockCharactersResults = testCharacterResultId1009144
    sut = CharactersListPresenter(dependencies: mockAppDependencies, coordinatorDelegate: mockCoordinator, interactor: mockCharactersListInteractor!)
  }

  // MARK: - TEST API FUNCTIONS
  func test() throws {

    let testResults: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))

    let testCharacterResultId1009144 = testResults.first!
    // TEST initial count is zero - charactersCount(at:)
    XCTAssert(sut.charactersCount() == 0 )

    // TEST getNextCharactersList(at:)
    sut.getNextCharactersList {
      // TEST count now is > zero - charactersCount()
      let charactersCount = self.sut.charactersCount()
      XCTAssert(charactersCount > 0 )

      // TEST character at index 0 has expected id - getCharacter(at:)
     let character = self.sut.getCharacter(at: 0)
      XCTAssert(character.id == testCharacterResultId1009144.id)

      XCTAssert(self.mockCoordinator.coordinatorState == .none)
      self.sut.didGoBack()
      self.mockCoordinator.coordinatorState = .didSelect(character: character)
    }
  }
}
