//
//  MockURLSessionDataTask.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit
import XCTest
import Rest

@testable import MarvelApiClient

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  func cancel() {
    fatalError()
  }

  private (set) var resumeWasCalled = false

  func resume() {
    resumeWasCalled = true
  }
}
