//
//  Utils.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 09/09/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import XCTest
@testable import MarvelApiClient

struct Animal: Encodable{
  let name: String = "cat"
  let isMammal: Bool = true
}

class Utils: XCTestCase {
  
  let sut = Character(name: "AA", imageUrl: nil, id: 0)
  
  func testExample() throws {
    let dict = try sut.toDictionary()
    print("result: \(dict)")
  }
}
