//
//  MarvelApiClientIntegrationTests.swift
//  MarvelApiClientTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
import Rest

@testable import MarvelApiClient

class MarvelApiClientIntegrationTests: XCTestCase {

  var sut: MarvelApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  override func setUpWithError() throws {
    let marvelApiConfig = MarvelApiRequestConfig()
    let restDependencies = RestDependencies(marvelApiConfig: marvelApiConfig)
    sut = MarvelApiClient(restDependencies: restDependencies)
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func testGetCharactersList() throws {
    let promise = expectation(description: "Characters array not empty")

    sut.getCharactersList { response  in
      XCTAssertNotNil(response)
      if case .failure = response {
        XCTAssertTrue(false)
      }
      promise.fulfill()
    }
    wait(for: [promise], timeout: 100)
  }

  func testGetCharacter() throws {
    let promise = expectation(description: "Character")
    let characterId = 1011334
    sut.getCharacter(with: characterId) { response in
      print("FB: character: \(response)")
      promise.fulfill()
      XCTAssertNotNil(response)
      if case .failure = response {
        XCTAssertTrue(false)
      }
    }
    wait(for: [promise], timeout: 30)
  }

  // MARK: - Comics
//  func testGetComicsList() throws {
//     XCTAssert(false)
//    let promise = expectation(description: "Comics array not empty")
//    sut.getComicsList { ( comics: [ComicResult])  in
//      print("FB: comics: \(comics)")
//      promise.fulfill()
//      XCTAssert(comics.isEmpty == false)
//    }
//    wait(for: [promise], timeout: 30)
//  }
//
//  func testGetComic() throws {
//    XCTAssert(false)
//    let promise = expectation(description: "Comic")
//    let comicId = 61537
//    sut.getComic(with: comicId) { comic in
//      print("FB: comic: \(comic)")
//      promise.fulfill()
//      XCTAssertNotNil(comic)
//    }
//    wait(for: [promise], timeout: 30)
//  }
}
