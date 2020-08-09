//
//  CharactersRepository.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol CharactersRepository {
//    @discardableResult
    func getCharactersList( //query: MovieQuery, page: Int,
//                         cached: @escaping (MoviesPage) -> Void,
      completion: @escaping (Result<[Character], Error>) -> Void)// -> Cancellable?

  func getCharacter(with id: Int, completion: @escaping (Result<Character, Error>) -> Void)
}
