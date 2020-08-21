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
  var appDependenciesDummy: AppDependenciesDummy!
  var mockIterator: MockCharacterDetailInteractor!

  override func setUpWithError() throws {
    mockIterator = MockCharacterDetailInteractor()
    appDependenciesDummy = AppDependenciesDummy(restDependencies: RestDependenciesMock(), charactersRepositoryMock: CharactersRepositoryMock())
  }

  /// TEST  sut creation using  init(dependencies: AppDependenciesProtocol, characterId: String)
  func testInitWithIterator() throws {

    // Given
    
    // CONFIGURE THE MOCK DATA
    let testResults: [Character]! = getCharactersEntitities(from: "MockedResponseGetCharacters")
    let testResult = testResults.first!
    mockIterator.mockCharacterDetailInteractorData.mockCharacterDetailResult = .success(testResult)
    sut = CharacterDetailPresenter(dependencies: appDependenciesDummy,
                                   character: testResult)
    XCTAssert(self.sut.getName() == testResult.name )
    XCTAssert(self.sut.getName() == testResult.name )
    XCTAssert(self.sut.getDescription() == "No Description Available")
    XCTAssert(self.sut.getThumbnailUrl() == URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg") )
    XCTAssert(self.sut.getComicsCount() == "Comics available: \(testResult.comics)" )
    XCTAssert(self.sut.getSeriesCount() == "Series available: \(testResult.series)" )
    XCTAssert(self.sut.getStoriesCount() == "Stories available: \(testResult.stories)")
  }
}


struct MockCharacterDetailInteractorData {
  var mockCharacterDetailResult: Result<Character, Error>?
}

class MockCharacterDetailInteractor: GetCharacterInteractorInputPort{

  weak var output: GetCharactersListInteractorOutputPort?

  var executeCalled = false

  var stubbedResult = Result<[Character], Error>.failure(MarvelError.noData)
  var asyncOpExpectation: XCTestExpectation?

  var mockCharacterDetailInteractorData = MockCharacterDetailInteractorData(mockCharacterDetailResult: nil)

  func execute(with id: Int) {
    executeCalled = true
    DispatchQueue.global().async {
      self.output?.domainData(result: self.stubbedResult )
      self.asyncOpExpectation?.fulfill()
    }
  }

//
//  func getCharacter(with characterId: Int, completion: @escaping (Result<CharacterResult, Error>) -> Void) {
//    completion(mockCharacterDetailInteractorData.mockCharacterDetailResult!)
//  }
}
