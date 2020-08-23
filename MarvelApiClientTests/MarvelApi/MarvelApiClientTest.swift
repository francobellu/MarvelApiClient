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

  func request<Req: ResponseRequestable>(with request: Req, completion: @escaping CompletionHandler<Req.Response>) -> NetworkCancellable? {
    completion(.success(self.request1Characters as! Req.Response))
    return NetworkCancellableMock()
  }

  func requestData<Req: ResponseRequestable>(with endpoint: Req, completion: @escaping CompletionHandler<Data>) -> NetworkCancellable? {
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
    let exp = XCTestExpectation(description: "async request")
    var testResult: Result<[CharacterResult], MarvelError> = .failure(.none) // This value will be overwritten during the test execution
    let expectedCharacters: [CharacterResult] = getDtos(from: "MockedResponseGetCharacters")
    var expectedResult: Result<[CharacterResult], MarvelError>  = .success(expectedCharacters)
    sut = MarvelApiClient(restDependencies: RestDependenciesMock())

    // When
    sut.getCharactersList { response in
      testResult = response
      exp.fulfill()
    }

    wait(for: [exp], timeout: 5)

    XCTAssertEqual(testResult, expectedResult)

    XCTAssertNotNil(testResult)
    switch testResult {
    case .success(let characters):

      XCTAssert(characters.count == expectedCharacters.count)
      for index  in characters.indices {
        XCTAssert(characters[index].id == expectedCharacters[index].id)
      }
    case .failure:
      XCTAssert(false)
    }

//    // TODO: test testResult directly!
//    guard case .success(let characters) = testResult else{ XCTFail()}
//    XCTAssert(testResult == expectedResult)

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
