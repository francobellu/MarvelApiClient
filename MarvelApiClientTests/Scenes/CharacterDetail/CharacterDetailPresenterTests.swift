//
//  CharactersListPresenterTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

import XCTest
@testable import MarvelApiClient

class CharacterDetailPresenterTest: XCTestCase {
  var sut: CharacterDetailPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
  let appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependencies())
  var mockIterator: MockCharacterDetailInteractor!

  override func setUpWithError() throws {
    mockIterator = MockCharacterDetailInteractor(dependencies: appDependenciesDummy)
  }

  /// TEST  sut creation using  init(dependencies: AppDependenciesProtocol, characterId: String)
  func testInitWithIterator() throws {

    // Given
    
    // CONFIGURE THE MOCK DATA
    let testResults: [CharacterResult] = getObjects(from: "MockedResponseGetCharacters")
    let testResult = testResults.first!
    mockIterator.mockCharacterDetailInteractorData.mockCharacterDetailResult = .success(testResult)
    sut = CharacterDetailPresenter(dependencies: appDependenciesDummy,
                                   characterId: Int(testResult.id!),
                                   interactor: mockIterator)
    XCTAssert(self.sut.getName() == testResult.name )
    XCTAssert(self.sut.getName() == testResult.name )
    XCTAssert(self.sut.getDescription() == "No Description Available")
    XCTAssert(self.sut.getThumbnailUrl() == URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg") )
    XCTAssert(self.sut.getComicsCount() == "Comics available: \(testResult.comics!.items!.count)" )
    XCTAssert(self.sut.getSeriesCount() == "Series available: \(testResult.series!.items!.count)" )
    XCTAssert(self.sut.getStoriesCount() == "Stories available: \(testResult.stories!.items!.count)")
  }
}


struct MockCharacterDetailInteractorData {
  var mockCharacterDetailResult: Result<CharacterResult, Error>?
}

class MockCharacterDetailInteractor: CharacterDetailInteractorProtocol{

  var mockCharacterDetailInteractorData = MockCharacterDetailInteractorData(mockCharacterDetailResult: nil)

  func getCharacter(with characterId: Int, completion: @escaping (Result<CharacterResult, Error>) -> Void) {
    completion(mockCharacterDetailInteractorData.mockCharacterDetailResult!)
  }

  required init(dependencies: AppDependenciesProtocol) {
  }
}
