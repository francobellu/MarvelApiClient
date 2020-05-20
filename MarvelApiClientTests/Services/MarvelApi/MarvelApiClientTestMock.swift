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

  override func setUpWithError() throws {

  }

  func testGetCharactersList() throws {

    let session = MockURLSession()
    session.nextData = mockContentData(for: "MockedResponseGetCharacters")
    let httpCLient = HttpClient(session: session)
    sut = MarvelApiClient(httpClient: httpCLient)

    let mockedResults: [CharacterResult]  = getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))

    sut.getCharactersList { response in
      print("FB: response: \(response)")

      XCTAssertNotNil(response)
      switch response {
      case .success(let dataContainer):

        XCTAssert(dataContainer.results.count == mockedResults.count)
        for index  in dataContainer.results.indices {
          XCTAssert(dataContainer.results[index].id == mockedResults[index].id)
        }
      case .failure(_):
        XCTAssert(false)
      }
    }
  }

  func testGetCharacter() throws {

    let session = MockURLSession()
    session.nextData = mockContentData(for: "MockedResponseGetCharacter")
    let httpCLient = HttpClient(session: session)
    sut = MarvelApiClient(httpClient: httpCLient)

    let mockedResult: CharacterResult = getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))

    sut.getCharacter(with: mockedResult.id!) { [mockedResult] response in
      XCTAssertNotNil(response)
      switch response {
      case .success(let dataContainer):
        XCTAssert(dataContainer.results.count == 1)
        XCTAssert(dataContainer.results[0].id == mockedResult.id)
      case .failure(_):
        XCTAssert(false)
      }
    }
  }
}

