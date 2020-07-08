//
//  TestUtils.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 18/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import XCTest

@testable import MarvelApiClient

extension XCTestCase{
  func mockContentData(for name: String ) -> Data {
      return getData(name: name)
  }

  func getData(name: String, withExtension: String = "json") -> Data {
      let testBundle = Bundle(for: type(of: self))
      let path = testBundle.path(forResource: name, ofType: "json")!
      let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped )
      return data
  }

  func getResults<T: Decodable> (from jsonData: Data) -> T {
    let response: MarvelResponse<T> = try! JSONDecoder().decode(MarvelResponse<T>.self, from: jsonData)

    return response.data!.results
  }

  func fetch<T: Decodable>(from file: String, completion: ( (T?,_ errorMessage: String?)->())? = nil  ) -> T? {
    var returnValue: T? = nil
    let testBundle = Bundle(for: type(of: self))
    guard let path = testBundle.path(forResource: file, ofType: "json") else{
      completion?(nil, "There is a problem in fetching the data")
      return nil
    }
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path) )
      let marvelResponse = try JSONDecoder().decode(MarvelResponse<T>.self, from: data)
      dump(marvelResponse)
      if let dataContainer = marvelResponse.data {
        returnValue = dataContainer.results
        completion?(returnValue, nil)
        //self.offset +=  self.limit
      } else {
        completion?(nil, "There is a problem in fetching the data")
      }
    } catch{
        completion?(nil, "There is a problem in fetching the data")
    }
    return returnValue
  }

//  func handleResponse<T: APIRequest>( data: Data?, error: Error?,  completion: @escaping ResultCallback<DataContainer<T.Response>>) throws -> T {
//    if let data = data {
//      do {
//        let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)
//        dump(marvelResponse)
//        if let dataContainer = marvelResponse.data {
//          completion(.success(dataContainer))
//        } else {
//          completion(.failure(MarvelError.decoding))
//        }
//      } catch {
//        _ = try? JSONDecoder().decode(ErrorResponse.self, from: data)
//        completion(.failure(MarvelError.decoding))
//      }
//    } else if let error = error {
//      completion(.failure(error))
//    }
//  }
}
