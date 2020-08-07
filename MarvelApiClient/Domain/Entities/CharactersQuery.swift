//
//  CharactersQuery.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

struct CharactersQuery: Equatable {
  let name: String?
  let nameStartsWith: String?
  let limit: Int?
  let offset: Int?
}
