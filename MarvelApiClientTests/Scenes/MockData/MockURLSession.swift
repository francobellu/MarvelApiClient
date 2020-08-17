//
//  MockURLSession.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit
import XCTest


//@testable import MarvelApiClient
//
//// MARK: MOCK
//class MockURLSession: URLSessionProtocol {
//
//  var nextDataTask = MockURLSessionDataTask()
//  var nextData: Data?
//  var nextError: Error?
//
//  private (set) var lastURL: URL?
//
//  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResultCompletion) -> URLSessionDataTaskProtocol {
//    lastURL = request.url
//
//    completionHandler(nextData, successHttpURLResponse(request: request), nextError)
//    return nextDataTask
//  }
//
//  func successHttpURLResponse(request: URLRequest) -> URLResponse {
//    guard let url = request.url,
//      let httpResponse = HTTPURLResponse(url: url,
//                                         statusCode: 200,
//                                         httpVersion: "HTTP/1.1",
//                                         headerFields: nil)
//      else {fatalError() }
//
//    return httpResponse
//  }
//}
