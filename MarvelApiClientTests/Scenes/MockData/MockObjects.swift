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


class MockApiClient: MarvelApiProtocol{
  /// Used to configure the test case
  var mockApiClientData = MockApiCLientData(mockCharactersResults: nil,
                                            mockCharacterResults: nil,
                                            mockComicsData: nil,
                                            mockComicData: nil)

  func getCharactersList(completion: @escaping (Result<[CharacterResult], MarvelError>) -> Void) {
    if let results = mockApiClientData.mockCharactersResults{
      completion(.success(results ))
    } else{
      completion(.failure(MarvelError.noData))
    }
  }

  func getCharacter(with id: Int, completion: @escaping (Result<[CharacterResult], MarvelError>) -> Void) {
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



