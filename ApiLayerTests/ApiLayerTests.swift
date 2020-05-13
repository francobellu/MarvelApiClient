//
//  ApiLayerTests.swift
//  ApiLayerTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest

@testable import ApiLayer

class ApiLayerTests: XCTestCase {

  var sut: MarvelAPIClient!

  override func setUpWithError() throws {
    let session = URLSession(configuration: .default)
    let httpCLient = HttpClient(session: session, httpConfigProtocol: MarvelHttpConfig())
    sut = MarvelAPIClient(httpClient: httpCLient)
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func testGetCharactersList() throws {
    let promise = expectation(description: "Characters array not empty")
    sut.getCharactersList { ( characters: [CharacterResult])  in
      print("FB: characters: \(characters)")
      promise.fulfill()
      XCTAssert(characters.isEmpty == false)
    }
    wait(for: [promise], timeout: 30)
  }

  func testGetCharacter() throws {

    let promise = expectation(description: "Character")
    let characterId = 1011334
    sut.getCharacter(with: characterId) { character in
      print("FB: character: \(character)")
      promise.fulfill()
      XCTAssertNotNil(character)
    }
    wait(for: [promise], timeout: 30)
  }

  // MARK: - Comics
  func testGetComicsList() throws {
    let promise = expectation(description: "Comics array not empty")
    sut.getComics { ( comics: [ComicResult])  in
      print("FB: comics: \(comics)")
      promise.fulfill()
      XCTAssert(comics.isEmpty == false)
    }
    wait(for: [promise], timeout: 30)
  }

  func testGetComic() throws {

    let promise = expectation(description: "Comic")
    let comicId = 61537
    sut.getComic(with: comicId) { comic in
      print("FB: comic: \(comic)")
      promise.fulfill()
      XCTAssertNotNil(comic)
    }
    wait(for: [promise], timeout: 30)
  }
}
