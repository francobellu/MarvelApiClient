//
//  MarvelApiClientTestMock.swift
//  MarvelApiClientTests
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
import Rest

@testable import MarvelApiClient
class RestDependenciesMock: RestDependenciesProtocol{

  // MARK: - RestDependenciesProtocol
  var restApiClient: RestApiClient

  var marvelApiClient: MarvelApiProtocol{
    MarvelApiClient(restDependencies: self)
  }

  var apiRequestConfig: RestServiceConfigProtocol = MarvelApiRequestConfig()

  var method: RestMethod = .get

  init(sessionNextData: Data) {
    let sessionManager = NetworkSessionManagerMock(response: HTTPURLResponse(), data: sessionNextData, error: nil)
    restApiClient = RestApiClient(sessionManager: sessionManager, logger: NetworkErrorLoggerMock())
  }
}

class MarvelApiClientCharactersTestMock: XCTestCase {

  var sut: MarvelApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  func testGetCharactersList() throws {

    let testNextData: Data = mockResponseData(for: "MockedResponseGetCharacters")
    sut = MarvelApiClient(restDependencies: RestDependenciesMock(sessionNextData: testNextData))

    let testResult: [CharacterResult]  = getDtos(from: "MockedResponseGetCharacters")

    sut.getCharactersList { response in
      print("FB: response: \(response)")

      XCTAssertNotNil(response)
      switch response {
      case .success(let characters):

        XCTAssert(characters.count == testResult.count)
        for index  in characters.indices {
          XCTAssert(characters[index].id == testResult[index].id)
        }
      case .failure(_):
        XCTAssert(false)
      }
    }
  }

  func testGetCharacter() throws {

    let testNextData = mockResponseData(for: "MockedResponseCharacterResultId1011334")
    sut = MarvelApiClient(restDependencies: RestDependenciesMock(sessionNextData: testNextData))

    let testResults: [CharacterResult] = getDtos(from: "MockedResponseGetCharacters")
    let testResult = testResults.first!

    sut.getCharacter(with: testResult.id!) { result in
      XCTAssertNotNil(result)
      switch result {
      case .success(let characters):
        XCTAssert(characters.count == 1)
        XCTAssert(characters.first!.id == testResult.id)
      case .failure(_):
        XCTAssert(false)
      }
    }
  }
}

struct NetworkSessionManagerMock: NetworkSessionManager {
  let response: HTTPURLResponse?
  let data: Data?
  let error: Error?

  func request(_ request: URLRequest,
               completion: @escaping CompletionHandler) -> NetworkCancellable {
    completion(data, response, error)
    return URLSessionDataTask()
    //    URLSession.shared.dataTask(with: request)
    //    return URLSession.shared.dataTask(with: request)
  }
}

class NetworkErrorLoggerMock: NetworkErrorLogger {
    var loggedErrors: [Error] = []
    func log(request: URLRequest) { }
    func log(responseData data: Data?, response: URLResponse?) { }
    func log(error: Error) { loggedErrors.append(error) }
}
