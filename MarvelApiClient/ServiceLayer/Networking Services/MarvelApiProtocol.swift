//
//  MarvelApiProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol MarvelApiProtocol {
  // Characters
  func getCharactersList(completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void)
  func getCharacter(with id: Int, completion:  @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void)

  // Comics
  func getComicsList(completion: @escaping ([ComicResult]) -> Void)
  func getComicsAvengers(completion: @escaping ([ComicResult]) -> Void)

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void)
}
