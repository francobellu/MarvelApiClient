//
//  MockApiClient.swift
//  MarvelApiClientTests
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
@testable import MarvelApiClient

struct MockApiCLientData {
  var mockCharactersResults: [CharacterResult]?
  var mockCharacterResults: [CharacterResult]?
  let mockComicsData: [ComicResult]?
  let mockComicData: ComicResult?
}
