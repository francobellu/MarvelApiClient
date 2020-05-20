//
//  CharactersListPresenterTests.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//
//  PresentationLayer.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient

class MockCharacterDetailInteractor: CharacterDetailInteractorProtocol{
  func getCharacter(with characterId: Int, completion: @escaping (CharacterResult) -> Void) {
    //    TODO:
  }

  required init(dependencies: AppDependenciesProtocol) {

  }
}

class CharacterDetailPresenterTest: XCTestCase {
  var sut: CharacterDetailPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
  let mockAppDependencies = MockAppDependencies()
  var testCharacterResultId1011334: CharacterResult!
  var testCharacterResultId1009144: CharacterResult!
  var mockIterator: CharacterDetailInteractorProtocol!

  override func setUpWithError() throws {

    // CONFIGURE THE MOCK DATA
    let results: [CharacterResult]  = getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))
    testCharacterResultId1011334 = results.first!
    mockIterator = MockCharacterDetailInteractor(dependencies: mockAppDependencies)
  }

  // MARK: - TEST API FUNCTIONS


  /// TEST  sut creation using  init(dependencies: AppDependenciesProtocol, characterId: String)
  func testInitFromIterator() throws {
    sut = CharacterDetailPresenter(dependencies: mockAppDependencies,
                                   characterId: String(testCharacterResultId1011334.id!),
                                   interactor: mockIterator)
    XCTAssert(self.sut.getName() == "Character Detail" )
    XCTAssert(self.sut.getDescription() == "No Description Available")
    XCTAssert(self.sut.getThumbnailUrl() == URL(string: "") )
    XCTAssert(self.sut.getComicsCount() == "" )
    XCTAssert(self.sut.getSeriesCount() == "" )
    XCTAssert(self.sut.getStoriesCount() == "" )

    sut.getCharacter(with: testCharacterResultId1011334.id!){
     // TEST current character corresponds to testCharacterResultId1011334
      let name = !self.testCharacterResultId1011334.name!.isEmpty ? self.testCharacterResultId1011334.name : "Character Detail"
      XCTAssert(self.sut.getName() == name )
      let descr = !self.testCharacterResultId1011334.description!.isEmpty ? self.testCharacterResultId1011334.description! : "No Description Available"
      XCTAssert(self.sut.getDescription() == descr)
      XCTAssert(self.sut.getThumbnailUrl() == URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg") )
      let comicsCount = "Comics available: \((self.testCharacterResultId1011334.comics!.items?.count)!)"
      XCTAssert(self.sut.getComicsCount() == String(comicsCount) )
      let seriesCount = "Series available: \((self.testCharacterResultId1011334.series!.items?.count)!)"
      XCTAssert(self.sut.getSeriesCount() == String(seriesCount) )
      let storiesCount = "Stories available: \((self.testCharacterResultId1011334.stories!.items?.count)!)"
      XCTAssert(self.sut.getStoriesCount() == String(storiesCount) )
    }
  }
}
