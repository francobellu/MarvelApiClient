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
  let mockAppDependencies = MockAppDependencies()
  var mockIterator: MockCharacterDetailInteractor!

  func setUpWithError() throws {
    mockIterator = MockCharacterDetailInteractor(dependencies: mockAppDependencies)
  }

  /// TEST  sut creation using  init(dependencies: AppDependenciesProtocol, characterId: String)
  func testInitWithIterator() throws {

    // CONFIGURE THE MOCK DATA
    let testResults: [CharacterResult] = getResults(from: mockContentData(for: "MockedResponseGetCharacters"))
    let testResult = testResults.first!
    mockIterator.mockCharacterDetailInteractorData.mockCharacterDetailResult = testResult
    sut = CharacterDetailPresenter(dependencies: mockAppDependencies,
                                   characterId: String(testResult.id!),
                                   interactor: mockIterator)
    XCTAssert(self.sut.getName() == "Character Detail" )
    XCTAssert(self.sut.getDescription() == "No Description Available")
    XCTAssert(self.sut.getThumbnailUrl() == URL(string: "") )
    XCTAssert(self.sut.getComicsCount() == "" )
    XCTAssert(self.sut.getSeriesCount() == "" )
    XCTAssert(self.sut.getStoriesCount() == "" )

    sut.getCharacter(with: testResult.id!){
     // TEST current character corresponds to testCharacterResultId1011334
      let name = !testResult.name!.isEmpty ? testResult.name : "Character Detail"
      XCTAssert(self.sut.getName() == name )
      let descr = !testResult.description!.isEmpty ? testResult.description! : "No Description Available"
      XCTAssert(self.sut.getDescription() == descr)
      XCTAssert(self.sut.getThumbnailUrl() == URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg") )
      let comicsCount = "Comics available: \((testResult.comics!.items?.count)!)"
      XCTAssert(self.sut.getComicsCount() == String(comicsCount) )
      let seriesCount = "Series available: \((testResult.series!.items?.count)!)"
      XCTAssert(self.sut.getSeriesCount() == String(seriesCount) )
      let storiesCount = "Stories available: \((testResult.stories!.items?.count)!)"
      XCTAssert(self.sut.getStoriesCount() == String(storiesCount) )
    }
  }
}
