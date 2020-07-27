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

// Get the MarvelResponse data structure from a file. The file needs to be a valid representation of  MarvelResponse data struct
func getResponse<T: Decodable>(from file: String, completion: ( (MarvelResponse<T>,_ errorMessage: String?)->())? = nil  ) -> MarvelResponse<T> {
  var returnValue: MarvelResponse<T>
  let testBundle = Bundle(for:  GetCharactersListInteractorInputPortTest.self)
  guard let url = testBundle.url(forResource: file, withExtension: "json") else{
    fatalError()
    //      completion?(nil, "There is a problem in fetching the data")
    //      return nil
  }
  do {
    let data = try Data(contentsOf: url)
    print("T type:\(T.self)")
    let marvelResponse = try JSONDecoder().decode(MarvelResponse<T>.self, from: data)
    
    // dump(marvelResponse, name: "test marvelResponse", maxDepth: 1)
    
    returnValue = marvelResponse
    completion?(returnValue, nil)
  } catch{
    print(error)
    fatalError(error.localizedDescription)
    //        completion?(nil, "There is a problem in fetching the data")
  }
  return returnValue
}

// Get the T Objects ( [CharacterResult] or [ComicResult])  from a json file. The file needs to be a valid representation of  the T data struct
func getObjects<T: Decodable>(from file: String, completion: ( (T,_ errorMessage: String?)->())? = nil  ) -> T {
  var returnValue: T
  let testBundle = Bundle(for:  GetCharactersListInteractorInputPortTest.self)
  guard let path = testBundle.path(forResource: file, ofType: "json") else{
    fatalError()
    //      completion?(nil, "There is a problem in fetching the data")
    //      return nil
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
      fatalError()
      //        completion?(nil, "There is a problem in fetching the data")
    }
  } catch{
    fatalError()
    //        completion?(nil, "There is a problem in fetching the data")
  }
  return returnValue
}

func mockResponseData(for name: String ) -> Data {
    let testBundle = Bundle(for:  GetCharactersListInteractorInputPortTest.self)
    let path = testBundle.path(forResource: name, ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped )
    return data
}
