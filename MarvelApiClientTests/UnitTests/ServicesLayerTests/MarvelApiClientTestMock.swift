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

  var sut: MarvelAPIClient! // swiftlint:disable:this implicitly_unwrapped_optional

  override func setUpWithError() throws {
    let session = MockURLSession()
    session.nextData = mockContentData(for: "MockedResponseGetCharacters")
    let httpCLient = HttpClient(session: session)
    sut = MarvelAPIClient(httpClient: httpCLient)
  }

  override func tearDownWithError() throws {
  }

  func testGetCharactersList() throws {
    sut.getCharactersList { ( characters: [CharacterResult])  in
      print("FB: characters: \(characters)")
      XCTAssert(characters.isEmpty == false)
      let mockedCharacters: [CharacterResult] = self.getObjec(from: self.mockContentData(for: "MockedResponseGetCharacters"))
      XCTAssert(characters.count == mockedCharacters.count )
      }
  }
}

class MarvelApiClientCharacterTestMock: XCTestCase {

  var sut: MarvelAPIClient! // swiftlint:disable:this implicitly_unwrapped_optional

  override func setUpWithError() throws {
    let session = MockURLSession()
    session.nextData = mockContentData(for: "MockedResponseGetCharacter")
    let httpCLient = HttpClient(session: session)
    sut = MarvelAPIClient(httpClient: httpCLient)
  }

  override func tearDownWithError() throws {
  }

  let characterId_1011334 = 1011334
  func testGetCharacter() throws {
    sut.getCharacter(with: characterId_1011334){ ( character: CharacterResult)  in
      let mockedCharacter: CharacterResult = self.getObjec(from: self.mockContentData(for: "MockedResponseGetCharacter"))
      XCTAssert(character.name == mockedCharacter.name )
      XCTAssert(character.description == mockedCharacter.description )
      XCTAssert(character.id == mockedCharacter.id)
      }
  }

}
