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

  var sut: GetCharactersListInteractor! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()
  var mockApiClient: MockApiClient!{
    mockAppDependencies.marvelApiClient as? MockApiClient
  }
  let interactorOutputPortMock = GetCharactersListInteractorOutputPortMock()

  override func setUpWithError() throws {
    sut = GetCharactersListInteractor(dependencies: mockAppDependencies)
    sut.presenterDelegate = interactorOutputPortMock
  }

  // MARK: - Business logic
  func testSuccess() throws {
    // CONFIGURE THE MOCK DATA WITH AN ARRAY OF EMPTY CharacterResult
    let testResponse: MarvelResponse<CharacterResult> = getResponse(from: "MockedResponseGetCharacters")
    XCTAssertTrue(testResponse.code == 200)
    guard let testData = testResponse.data else{
      XCTAssert(true, "data should exist")
      return
    }
    XCTAssertTrue(testData.results.count == 20 )
    sut.execute()

    XCTAssertNotNil(interactorOutputPortMock.characters)
    XCTAssertNotNil(interactorOutputPortMock.characters.count == testData.results.count)
  }

  func testFailure() throws {
    let response: MarvelResponse<CharacterResult> = getResponse(from: "MockedResponseGetCharacters")
    XCTAssertTrue(response.code == 404)
    sut.execute()
  }
}

class GetCharactersListInteractorOutputPortMock: GetCharactersListInteractorOutputPort{
  var characters = [CharacterResult]()
  lazy var interactorCompletion: (([CharacterResult]) -> Void)? = { charactersResults in
    self.characters = charactersResults
  }
}
