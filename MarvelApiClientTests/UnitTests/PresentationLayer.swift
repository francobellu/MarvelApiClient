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

  var sut: OnboardingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
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

  var sut: LandingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
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

  lazy var marvelApiClient: MarvelAPIProtocol = {
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

class MockApiClient:  MarvelAPIProtocol{
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

  var sut: CharactersListViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()
  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
  
  override func setUpWithError() throws {
    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient

    let testCharacterResultId1009144: [CharacterResult] =  getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))
    mockApiClient.mockApiClientData.mockCharactersData = testCharacterResultId1009144
    sut = CharactersListViewModel(dependencies: mockAppDependencies, coordinatorDelegate: mockCoordinator)
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

  var sut: CharacterDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  let mockAppDependencies = MockAppDependencies()

  var testCharacterResultId1011334: CharacterResult! = nil
  var testCharacterResultId1009144: CharacterResult! = nil

  override func setUpWithError() throws {
    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient

//    testCharacterResultId1011334 = getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))
    mockApiClient.mockApiClientData.mockCharacterData = getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))

    let testCharacterResultId1009144: [CharacterResult]  =  getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1009144"))
    sut = CharacterDetailViewModel(dependencies: mockAppDependencies, character: testCharacterResultId1009144.first!)

//    let testCharacterResultId1011334: CharacterResult =  getObjec(from: mockContentData(for: "MockedResponseCharacterResultId1011334"))

  }

  // MARK: - TEST API FUNCTIONS
  func testGetCharacter() throws {

    XCTAssert(self.sut.getName() == testCharacterResultId1011334.name )
    XCTAssert(self.sut.getDescription() == testCharacterResultId1011334.name )
    let comicsCount = (testCharacterResultId1011334.comics!.items?.count)!
    XCTAssert(self.sut.getComicsCount() == String(comicsCount) )
    let seriesCount = (testCharacterResultId1011334.comics!.items?.count)!
    XCTAssert(self.sut.getSeriesCount() == String(seriesCount) )
    let storiesCount = (testCharacterResultId1011334.comics!.items?.count)!
    XCTAssert(self.sut.getStoriesCount() == String(storiesCount) )

    let characterId = testCharacterResultId1009144.id!

    // TEST getNextCharactersList(at:)
    sut.getCharacter(with: characterId){
      XCTAssert(self.sut.getName() == self.testCharacterResultId1009144.name )
      XCTAssert(self.sut.getDescription() == self.testCharacterResultId1009144.name )
      let comicsCount = (self.testCharacterResultId1009144.comics!.items?.count)!
      XCTAssert(self.sut.getComicsCount() == String(comicsCount) )
      let seriesCount = (self.testCharacterResultId1009144.comics!.items?.count)!
      XCTAssert(self.sut.getSeriesCount() == String(seriesCount) )
      let storiesCount = (self.testCharacterResultId1009144.comics!.items?.count)!
      XCTAssert(self.sut.getStoriesCount() == String(storiesCount) )
    }
  }

  func testFromDeepLink() throws {

    let characterIdAt0 = 1011334
    // TEST getNextCharactersList(at:)
    sut.getCharacter(with: characterIdAt0){

      // TEST
      XCTAssert(self.sut.getName() == "3-D Man" )
      XCTAssert(self.sut.getDescription() == "" )
      XCTAssert(self.sut.getComicsCount() == "12" )
      XCTAssert(self.sut.getSeriesCount() == "3" )
      XCTAssert(self.sut.getStoriesCount() == "21" )
    }
  }

}

//
//class CharacterDetailViewModelTest: XCTestCase {
//
//  var sut: CharacterDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
//  override func setUpWithError() throws {
//
//  }
//  override func tearDownWithError() throws {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//  }
//
//  func testExample() throws {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//  }
//
//  func testPerformanceExample() throws {
//    // This is an example of a performance test case.
//    self.measure {
//      // Put the code you want to measure the time of here.
//    }
//  }
//}
//
//class ComicsListViewModelTest: XCTestCase {
//
//  var sut: ComicsListViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
//  override func setUpWithError() throws {
//
//  }
//  override func tearDownWithError() throws {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//  }
//
//  func testExample() throws {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//  }
//
//  func testPerformanceExample() throws {
//    // This is an example of a performance test case.
//    self.measure {
//      // Put the code you want to measure the time of here.
//    }
//  }
//}
//
//
//class ComicDetailViewModelTest: XCTestCase {
//
//  var sut: ComicDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
//  override func setUpWithError() throws {
//
//  }
//  override func tearDownWithError() throws {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//  }
//
//  func testExample() throws {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//  }
//
//  func testPerformanceExample() throws {
//    // This is an example of a performance test case.
//    self.measure {
//      // Put the code you want to measure the time of here.
//    }
//  }
//}
//
