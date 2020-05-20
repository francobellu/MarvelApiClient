//
//  PresentationLayer.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 19/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient

class OnboardingViewModelTest: XCTestCase {

  var sut: OnboardingPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
  override func setUpWithError() throws {

  }
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}

class LandingViewModelTest: XCTestCase {

  var sut: LandingPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
  override func setUpWithError() throws {

  }
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
}

enum CoordinatorState: Equatable{
  static func == (lhs: CoordinatorState, rhs: CoordinatorState) -> Bool {

    switch (lhs, rhs) {
    case (.none, .none):
      return true
    case (.didGoBack, .didGoBack):
      return true
    case (.didSelect(_), .didSelect(_)):
      return true
    default:
      return false
    }
  }

  case none
  case didGoBack
  case didSelect(character: CharacterResult)
}
class MockCharactersListCoordinatorDelegate:  CharactersListCoordinatorDelegate{
  var coordinatorState: CoordinatorState = .none

  func didGoBack() {
    coordinatorState  = .didGoBack
  }

  func didSelect(character: CharacterResult) {
    coordinatorState  = .didSelect(character: character)
  }
}

class MockAppDependencies: AppDependenciesProtocol {
  // MARK: - All the app dependencies

  let mockData: String = ""

  lazy var httpClient: HttpClient = {
    return HttpClient(session: MockURLSession())
  }()

  lazy var marvelApiClient: MarvelApiProtocol = {
    return MockApiClient()
  }()

  lazy var dataStore: DataStoreProtocol = {
    UserDefaultsDataStore()
  }()

  lazy var appConfig: AppConfig = {
    AppConfig()
  }()
}

struct MockApiCLientData {
  var mockCharacterData: CharacterResult?
  var mockCharactersData: [CharacterResult]?
  let mockComicData: ComicResult?
  let mockComicsData: [ComicResult]?
  let mockComicsAvengersData: [ComicResult]?
}

class MockApiClient:  MarvelApiProtocol{
  var mockApiClientData = MockApiCLientData(mockCharacterData: nil,
                                            mockCharactersData: nil,
                                            mockComicData: nil,
                                            mockComicsData: nil,
                                            mockComicsAvengersData: nil)

  func getCharactersList(completion: @escaping ([CharacterResult]) -> Void) {
    completion( self.mockApiClientData.mockCharactersData!)
  }

  func getCharacter(with id: Int, completion: @escaping (CharacterResult) -> Void) {
    completion( self.mockApiClientData.mockCharacterData!)
  }

  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
    completion(self.mockApiClientData.mockComicsData!)
  }

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
    completion( self.mockApiClientData.mockComicData!)
  }

  func getComicsAvengers(completion: @escaping ([ComicResult]) -> Void) {
    completion( self.mockApiClientData.mockComicsAvengersData!)
  }

}

class CharactersListViewModelTest: XCTestCase {

  var sut: CharactersListPresenter! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  
  override func setUpWithError() throws {
    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient

    let testCharacterResultId1009144: [CharacterResult] =  getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))
    mockApiClient.mockApiClientData.mockCharactersData = testCharacterResultId1009144
    sut = CharactersListPresenter(dependencies: mockAppDependencies, coordinatorDelegate: mockCoordinator)
  }

  // MARK: - TEST API FUNCTIONS
  func test() throws {

    // TEST initial count is zero - charactersCount(at:)
    XCTAssert(sut.charactersCount() == 0 )

    // TEST getNextCharactersList(at:)
    sut.getNextCharactersList {
      // TEST count now is > zero - charactersCount()
      let charactercount = self.sut.charactersCount()
      XCTAssert(charactercount > 0 )

      // TEST character at index 0 has expected id - getCharacter(at:)
      let character = self.sut.getCharacter(at: 0)
      let characterIdAt0 = 1011334
      XCTAssert(character.id == characterIdAt0)

      XCTAssert(self.mockCoordinator.coordinatorState == .none)
      self.sut.didGoBack()
      self.mockCoordinator.coordinatorState = .didSelect(character: character)
    }
  }
}

class CharacterDetailViewModelTest: XCTestCase {
  var sut: CharacterDetailPresenter! // swiftlint:disable:this implicitly_unwrapped_optional
  let mockAppDependencies = MockAppDependencies()
  var testCharacterResultId1011334: CharacterResult!
  var testCharacterResultId1009144: CharacterResult!

  override func setUpWithError() throws {

    // CONFIGURE THE MOCK DATA
    let results: [CharacterResult]  = getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))
    testCharacterResultId1011334 = results.first!

    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient
    mockApiClient.mockApiClientData.mockCharacterData = testCharacterResultId1011334

  }

  // MARK: - TEST API FUNCTIONS

  /// TEST  sut creation using init(dependencies: AppDependenciesProtocol, character: CharacterResult)
  func testInit1() throws {
    sut = CharacterDetailPresenter(dependencies: mockAppDependencies, character: testCharacterResultId1011334)

    // TEST current character corresponds to testCharacterResultId1011334
    let name = !testCharacterResultId1011334.name!.isEmpty ? testCharacterResultId1011334.name : "Character Detail"
    XCTAssert(sut.getName() == name )
    let descr = !testCharacterResultId1011334.description!.isEmpty ? testCharacterResultId1011334.description! : "No Description Available"
    XCTAssert(sut.getDescription() == descr)
    XCTAssert(sut.getThumbnailUrl() == URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg") )
    let comicsCount = "Comics available: \((testCharacterResultId1011334.comics!.items?.count)!)"
    XCTAssert(sut.getComicsCount() == String(comicsCount) )
    let seriesCount = "Series available: \((testCharacterResultId1011334.series!.items?.count)!)"
    XCTAssert(sut.getSeriesCount() == String(seriesCount) )
    let storiesCount = "Stories available: \((testCharacterResultId1011334.stories!.items?.count)!)"
    XCTAssert(sut.getStoriesCount() == String(storiesCount) )
  }

  /// TEST  sut creation using  init(dependencies: AppDependenciesProtocol, characterId: String)
  func testInit2() throws {
    sut = CharacterDetailPresenter(dependencies: mockAppDependencies, characterId: String(testCharacterResultId1011334.id!))
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
