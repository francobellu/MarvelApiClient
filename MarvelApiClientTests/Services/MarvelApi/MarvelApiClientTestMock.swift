//
//  MarvelApiClientTestMock.swift
//  MarvelApiClientTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest

@testable import MarvelApiClient

class MarvelApiClientCharactersTestMock: XCTestCase {

  var sut: MarvelApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  func setUpWithError() throws {

  }

  func testGetCharactersList() throws {

    let session = MockURLSession()
    session.nextData = mockContentData(for: "MockedResponseGetCharacters")
    let restApiClient = RestApiClient(session: session)
    sut = MarvelApiClient(restApiClient: restApiClient)

    let testResult: [CharacterResult]  = getResults(from: mockContentData(for: "MockedResponseGetCharacters"))

    sut.getCharactersList { response in
      print("FB: response: \(response)")

      XCTAssertNotNil(response)
      switch response {
      case .success(let dataContainer):

        XCTAssert(dataContainer.results.count == testResult.count)
        for index  in dataContainer.results.indices {
          XCTAssert(dataContainer.results[index].id == testResult[index].id)
        }
      case .failure(_):
        XCTAssert(false)
      }
    }
  }

  func testGetCharacter() throws {

    let session = MockURLSession()
    session.nextData = mockContentData(for: "MockedResponseCharacterResultId1011334")
    let restApiClient = RestApiClient(session: session)
    sut = MarvelApiClient(restApiClient: restApiClient)

    let testResults: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))
    let testResult = testResults.first!

    sut.getCharacter(with: testResult.id!) { result in
      XCTAssertNotNil(result)
      switch result {
      case .success(let dataContainer):
        XCTAssert(dataContainer.results.count == 1)
        XCTAssert(dataContainer.results[0].id == testResult.id)
      case .failure(_):
        XCTAssert(false)
      }
    }
  }
}


