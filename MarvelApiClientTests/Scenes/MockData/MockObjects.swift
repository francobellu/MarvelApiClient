//
//  MockURLSession.swift
//  MarvelApiClientTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit
import XCTest

@testable import MarvelApiClient

// MARK: MOCK
class MockURLSession: URLSessionProtocol {

  var nextDataTask = MockURLSessionDataTask()
  var nextData: Data?
  var nextError: Error?

  private (set) var lastURL: URL?

  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    lastURL = request.url

    completionHandler(nextData, successHttpURLResponse(request: request), nextError)
    return nextDataTask
  }

  func successHttpURLResponse(request: URLRequest) -> URLResponse {
    guard let url = request.url,
      let httpResponse = HTTPURLResponse(url: url,
                                         statusCode: 200,
                                         httpVersion: "HTTP/1.1",
                                         headerFields: nil)
      else {fatalError() }

    return httpResponse
  }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  private (set) var resumeWasCalled = false

  func resume() {
    resumeWasCalled = true
  }
}


class OnboardingPresenterlTest: XCTestCase {

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

class LandingPresenterTest: XCTestCase {

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

class MockApiClient: MarvelApiProtocol{
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
