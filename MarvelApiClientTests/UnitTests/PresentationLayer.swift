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
  let mockCharacterData: CharacterResult?
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
    mockApiClient.mockApiClientData.mockCharactersData =  self.getObjec(from: self.mockContentData(for: "MockedResponseGetCharacters"))
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

//class CharacterDetailViewModelTest: XCTestCase {
//
//  var sut: CharacterDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
//
//  let mockAppDependencies = MockAppDependencies()
//  let mockCoordinator =  MockCharactersListCoordinatorDelegate()
//
//  override func setUpWithError() throws {
//    let mockApiClient = mockAppDependencies.marvelApiClient as! MockApiClient
//    mockApiClient.mockApiClientData.mockCharactersData =  self.getObjec(from: self.mockContentData(for: "MockedResponseGetCharacter"))
//    sut = CharacterDetailViewModel(dependencies: mockAppDependencies, coordinatorDelegate: mockCoordinator)
//  }
//
//  // MARK: - TEST API FUNCTIONS
//  func test() throws {
//
//    let characterIdAt0 = 1011334
//    // TEST getNextCharactersList(at:)
//    sut.getCharacter(with: <#Int#>){
//
//      // TEST count now is > zero - charactersCount()
//      let charactercount = self.sut.charactersCount()
//      XCTAssert(charactercount > 0 )
//
//      // TEST character at index 0 has expected id - getCharacter(at:)
//      let character = self.sut.getCharacter(at: 0)
//
//      XCTAssert(character.id == characterIdAt0)
//
//      XCTAssert(self.mockCoordinator.coordinatorState == .none)
//      self.sut.didGoBack()
//      self.mockCoordinator.coordinatorState = .didSelect(character: character)
//    }
//  }
//}

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
