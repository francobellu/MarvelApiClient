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



class AppDependenciesDummy: AppDependenciesProtocol {
  // MARK: - All the app dependencies

  let mockData: String = ""

  lazy var restApiClient: RestApiClient = {
    return RestApiClient(session: MockURLSession())
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
  var mockCharactersResults: [CharacterResult]?
  var mockCharacterResults: CharacterResult?
  let mockComicsData: [ComicResult]?
  let mockComicData: ComicResult?
}

class MockApiClient: MarvelApiProtocol{

  /// Used to configure the test case
  var mockApiClientData = MockApiCLientData(mockCharactersResults: nil,
                                            mockCharacterResults: nil,
                                            mockComicsData: nil,
                                            mockComicData: nil)

  func getCharactersList(completion: @escaping (Result<[GetCharacters.Response], Error>) -> Void) {
    if let results = mockApiClientData.mockCharactersResults{
      completion(.success(results ))
    } else{
      completion(.failure(MarvelError.noData))
    }
  }

  func getCharacter(with id: Int, completion: @escaping (Result<GetCharacters.Response, Error>) -> Void) {
    if let result = mockApiClientData.mockCharacterResults{
      completion(.success(result))
    } else{
      completion(.failure(MarvelError.noData))
    }
  }

  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
    completion( mockApiClientData.mockComicsData!)
  }

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
    completion( mockApiClientData.mockComicData!)
  }
}



