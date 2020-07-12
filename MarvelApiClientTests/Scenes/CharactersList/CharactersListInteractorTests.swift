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
  
  override func setUpWithError() throws {
    sut = GetCharactersListInteractor(dependencies: mockAppDependencies)
  }

  // MARK: - Business logic
  func testSuccess() throws {
    // CONFIGURE THE MOCK DATA WITH AN ARRAY OF EMPTY CharacterResult
    let testResponse: MarvelResponse<CharacterResult> = getResponse(from: "MockedResponseGetCharacters")
    XCTAssertTrue(testResponse.code == 200)
    guard let data = testResponse.data else{
      XCTAssert(true, "data should exist")
      return
    }
    XCTAssertTrue(data.results.count == 20 )
    sut.execute { characters in
      XCTAssertNotNil(characters)
      XCTAssertNotNil(characters.count == data.results.count)
    }
  }

  func testFailure() throws {
    let response: MarvelResponse<CharacterResult> = getResponse(from: "MockedResponseGetCharacters")
    XCTAssertTrue(response.code == 404)
    sut.execute { characters in
    }
  }
}
