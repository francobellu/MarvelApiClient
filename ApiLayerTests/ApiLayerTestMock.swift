//
//  MarvelApiClientTestMock.swift
//  MarvelApiClientTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest

@testable import ApiLayer

class ApiLayerTestMock: XCTestCase {

  var sut: MarvelAPIClient!

  override func setUpWithError() throws {
    let session = MockURLSession()
    let httpCLient = HttpClient(session: session, httpConfigProtocol: MarvelHttpConfig())
    sut = MarvelAPIClient(httpClient: httpCLient)
  }

  override func tearDownWithError() throws {
  }

  func testgetCharactersList() throws {
    guard let url = URL(string: "https://mockurl") else {
      fatalError("URL can't be empty")
    }

    sut.getCharactersList { ( characters: [CharacterResult])  in
      print("FB: characters: \(characters)")
      //promise.fulfill()
      XCTAssert(characters.isEmpty == false)
    }

  }
}
