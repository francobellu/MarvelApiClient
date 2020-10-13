//
//  CharactersCache.swift
//  MarvelApiClient
//
//  Created by franco bellu on 10/09/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol CharactersCache{

  func getCharacters( completion: ([Character]) -> Void )

  func save( characters: [Character]) throws
}
