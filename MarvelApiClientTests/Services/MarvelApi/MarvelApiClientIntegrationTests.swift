//
//  MarvelApiClientIntegrationTests.swift
//  MarvelApiClientIntegrationTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
import Rest

@testable import MarvelApiClient

class MarvelApiClientIntegrationTests: XCTestCase {

  var session: URLSession! = nil
  var restApiClient: RestApiClient! = nil
//  var sut: MarvelApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  override func setUpWithError() throws {
    session = URLSession(configuration: .default)
    restApiClient = RestApiClient(session: session)
//    sut = MarvelApiClient(restApiClient: restApiClient)
  }

  override func tearDownWithError() throws {
    //    sut = nil
    session = nil
    restApiClient = nil
  }

  func testGetCharactersList() throws {
    // Given
    let promise = expectation(description: "Characters array not empty")

    // When
    let sut = GetCharacters(restDependencies: RestDependencies())
    sut.execute { (result: Result<[CharacterResult], Error>) in
      switch result {
      case .success(let characters):
        XCTAssertNotNil(characters)
        promise.fulfill()
      case .failure(let error):
        print(error)
        XCTAssert(false)
      }
    }
    wait(for: [promise], timeout: 100)

    // When
  }

  func testGetCharacter() throws {
     // Given
    let promise = expectation(description: "Character")
    let characterId = 1011334

    // When
    let sut = GetCharacter(restDependencies: RestDependencies(), id: characterId)
    sut.execute { (result: Result<GetCharacter.Response, Error>) in
      switch result {
      case .success(let characters):
        print("FB: character: \(characters)")
        XCTAssertNotNil(characters.first)
        promise.fulfill()
      case .failure(let error):
        print(error)
        XCTAssert(false)
      }
    }
    wait(for: [promise], timeout: 30)

    // When
  }

  // MARK: - Comics
  func testGetComicsList() throws {
     XCTAssert(false)
//    let promise = expectation(description: "Comics array not empty")
//    sut.getComicsList { ( comics: [ComicResult])  in
//      print("FB: comics: \(comics)")
//      promise.fulfill()
//      XCTAssert(comics.isEmpty == false)
//    }
//    wait(for: [promise], timeout: 30)
  }

  func testGetComic() throws {
    XCTAssert(false)
//    let promise = expectation(description: "Comic")
//    let comicId = 61537
//    sut.getComic(with: comicId) { comic in
//      print("FB: comic: \(comic)")
//      promise.fulfill()
//      XCTAssertNotNil(comic)
//    }
//    wait(for: [promise], timeout: 30)
  }
}
