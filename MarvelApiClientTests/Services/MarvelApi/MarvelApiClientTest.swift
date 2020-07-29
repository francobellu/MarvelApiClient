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

class RestDependenciesMock: RestDependenciesProtocol{

  // MARK: - RestDependenciesProtocol
  var restApiClient: RestApiClientProtocol

  var apiRequestConfig: RestServiceConfigProtocol = MarvelApiRequestConfig()

  var method: RestMethod = .get

  init(sessionNextData: Data) {
    let session = MockURLSession()
    session.nextData = sessionNextData

    restApiClient = RestApiClient(session:session)
  }
}

class MarvelApiClientCharactersTestMock: XCTestCase {

//  var sut: MarvelApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  func testGetCharactersList() throws {

    let nextData = mockResponseData(for: "MockedResponseGetCharacters")

    let restDependenciesMock = RestDependenciesMock(sessionNextData: nextData)

    let testResult: [CharacterResult]  = getObjects(from: "MockedResponseGetCharacters")

    let sut = GetCharacters(restDependencies: restDependenciesMock)


    sut.execute{ ( result: Result<[CharacterResult], Error>) in
      print("FB: response: \(result)")

      XCTAssertNotNil(result)
      switch result {
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

    let testResults: [CharacterResult] = getObjects(from: "MockedResponseGetCharacters")
    let testResult = testResults.first!


    let nextData = mockResponseData(for: "MockedResponseCharacterResultId1011334")

    let restDependenciesMock = RestDependenciesMock(sessionNextData: nextData)

    let sut = GetCharacter(restDependencies: restDependenciesMock, id: testResult.id!)

    sut.execute{ ( result: Result<[CharacterResult], Error>) in
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


