//
//  MarvelApiClientTestMock.swift
//  MarvelApiClientTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
import Rest

@testable import MarvelApiClient

class MarvelApiClientCharactersTestMock: XCTestCase {

  var sut: MarvelApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  func testGetCharactersList() throws {

    let session = MockURLSession()
    session.nextData = mockResponseData(for: "MockedResponseGetCharacters")
    let restApiClient = RestApiClient(session: session)
    sut = MarvelApiClient(restApiClient: restApiClient)

    let testResult: [CharacterResult]  = getObjects(from: "MockedResponseGetCharacters")

    sut.getCharactersList { response in
      print("FB: response: \(response)")

      XCTAssertNotNil(response)
      switch response {
      case .success(let characters):

        XCTAssert(characters.count == testResult.count)
        for index  in characters.indices {
          XCTAssert(characters[index].id == testResult[index].id)
        }
      case .failure(_):
        XCTAssert(false)
      }
    }
  }

  func testGetCharacter() throws {

    let session = MockURLSession()
    session.nextData = mockResponseData(for: "MockedResponseCharacterResultId1011334")
    let restApiClient = RestApiClient(session: session)
    sut = MarvelApiClient(restApiClient: restApiClient)

    let testResults: [CharacterResult] = getObjects(from: "MockedResponseGetCharacters")
    let testResult = testResults.first!

    sut.getCharacter(with: testResult.id!) { result in
      XCTAssertNotNil(result)
      switch result {
      case .success(let characters):
//        XCTAssert(characters.count == 1)
        XCTAssert(characters.first!.id == testResult.id)
      case .failure(_):
        XCTAssert(false)
      }
    }
  }
}


