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

class NetworkCancellableMock: NetworkCancellable {
  func cancel() {

  }
}

class RestServiceMock: RestService {

  private let request1Characters: [CharacterResult]
  private let request2Characters: [CharacterResult]
  private let request3Characters: [CharacterResult]

  required public init() {

    self.request1Characters = getDtos(from: "MockedResponseGetCharacters")
    self.request2Characters = getDtos(from: "MockedResponseGetCharacters")
    self.request3Characters = getDtos(from: "MockedResponseGetCharacters")
  }

  func request< Req: ResponseRequestable>(with request: Req,
  completion: @escaping (Result<Req.Response, Error>) -> Void) -> NetworkCancellable? {
    completion(.success(self.request1Characters as! Req.Response))
    return NetworkCancellableMock()
  }

  func requestData<Req: ResponseRequestable>(with request: Req,
  completion: @escaping (Result<Data, Error>) -> Void) -> NetworkCancellable? {
    return NetworkCancellableMock()
  }
}

class RestDependenciesMock: RestDependenciesProtocol {
  var restService: RestService = RestServiceMock()
}

class MarvelApiClientCharactersTest: XCTestCase {

  var sut: MarvelApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  func testGetCharactersList() throws {

    // Given
    let exp1 = XCTestExpectation(description: "async request")
    let exp2 = XCTestExpectation(description: "async request")
    let exp3 = XCTestExpectation(description: "async request")
    var testCharacters = [CharacterResult] ()

    let expectedCharacters1: [CharacterResult] = getDtos(from: "MockedResponseGetCharacters")
    let expectedCharacters2: [CharacterResult] = getDtos(from: "MockedResponseGetCharacters")
    let expectedCharacters3: [CharacterResult] = getDtos(from: "MockedResponseGetCharacters")

    let expectedCharacters: [CharacterResult] = expectedCharacters1 + expectedCharacters2 + expectedCharacters3
//    let expectedResult: Result<[CharacterResult], Error>  = .success(expectedCharacters)
    sut = MarvelApiClient(restDependencies: RestDependenciesMock())

    // When

    // fetch a first batchof 50 elements
    sut.getCharactersList { response in
      testCharacters +=  try! response.get()
      exp1.fulfill()
    }
    wait(for: [exp1], timeout: 5)

    sut.getCharactersList { response in
      testCharacters +=  try! response.get()
      exp2.fulfill()
    }
    wait(for: [exp2], timeout: 5)

    sut.getCharactersList { response in
      testCharacters +=  try! response.get()
      exp3.fulfill()
    }
    wait(for: [exp3], timeout: 5)

    // Then

    XCTAssert(testCharacters.count == expectedCharacters.count)
    for index in testCharacters.indices {
      XCTAssert(testCharacters[index].id == expectedCharacters[index].id)
    }
  }

//  func testGetCharacter() throws {
//
//    let testNextData = mockResponseData(for: "MockedResponseCharacterResultId1011334")
//    sut = MarvelApiClient(restDependencies: RestDependenciesMock(sessionNextData: testNextData))
//
//    let testResults: [CharacterResult] = getDtos(from: "MockedResponseGetCharacters")
//    let testResult = testResults.first!
//
//    sut.getCharacter(with: testResult.id!) { result in
//      XCTAssertNotNil(result)
//      switch result {
//      case .success(let characters):
//        XCTAssert(characters.count == 1)
//        XCTAssert(characters.first!.id == testResult.id)
//      case .failure(_):
//        XCTAssert(false)
//      }
//    }
//  }
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

class NetworkErrorLoggerMock: NetworkLogger {
    var loggedErrors: [Error] = []
    func log(request: URLRequest) { }
    func log(responseData data: Data?, response: URLResponse?) { }
    func log(error: Error) { loggedErrors.append(error) }
}

struct ApiNetworkConfigurationMock: NetworkConfigurable {
  var baseURL = URL(string: "www.mock.com")!
  var urlParameters: [String: String]?
  var encodableUrlParameters: Encodable?
  var headerParamaters: [String: String]?
  var bodyParameters: [String: String]?
  var encodableBodyParamaters: Encodable?
  var bodyEncoding: BodyEncoding?
}