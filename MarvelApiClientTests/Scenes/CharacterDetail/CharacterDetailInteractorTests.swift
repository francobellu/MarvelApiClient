//
//  PresentationLayer.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient


class CharacterDetailInteractorTest: XCTestCase {
  var sut: CharacterDetailInteractor! // swiftlint:disable:this implicitly_unwrapped_optional

  let appDependenciesDummy = AppDependenciesDummy()
  var mockApiClient: MockApiClient!

  override func setUpWithError() throws {
    mockApiClient = appDependenciesDummy.marvelApiClient as? MockApiClient
    sut = CharacterDetailInteractor(dependencies: appDependenciesDummy)
  }

  // MARK: - TEST Business logic

  /// TEST  sut creation using init(dependencies: AppDependenciesProtocol, character: CharacterResult)
  func testSuccess() throws {

    // CONFIGURE THE MOCK DATA
    let testCharacters: [CharacterResult] = getObjects(from: "MockedResponseGetCharacters")
//    let testDataContainer = DataContainer(offset: 0, limit: 20, total: 1000, count: 0, results: testCharacters)
    mockApiClient.mockApiClientData.mockCharacterResults = testCharacters.first!

    let testCharacter = testCharacters.first!
    sut.getCharacter(with: testCharacter.id!, completion: { characterResult in
      // TEST characters
      XCTAssertNotNil(characterResult)
      XCTAssertNotNil(characterResult?.id == testCharacter.id)
    })
  }

  func testFailure() throws {

    // CONFIGURE THE MOCK DATA WITH NIL
    mockApiClient.mockApiClientData.mockCharacterResults = nil

    let testCharacterId = 0
    sut.getCharacter(with: testCharacterId, completion: { characterResult in
      // TEST characters
      XCTAssertNil(characterResult)
    })
  }
}

struct MockCharacterDetailInteractorData {
  var mockCharacterDetailResult: CharacterResult?
}

class MockCharacterDetailInteractor: CharacterDetailInteractorProtocol{
  var mockCharacterDetailInteractorData = MockCharacterDetailInteractorData(mockCharacterDetailResult: nil)

  func getCharacter(with characterId: Int, completion: @escaping ((CharacterResult)?) -> Void) {
    completion(mockCharacterDetailInteractorData.mockCharacterDetailResult!)
  }

  required init(dependencies: AppDependenciesProtocol) {
  }
}
