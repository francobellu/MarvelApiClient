//
//  NetworkInterface.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol MarvelApiProtocol {
  // Characters
  func getCharactersList(completion: @escaping (Result<[CharacterResult], MarvelError>) -> Void)
  func getCharacter(with id: Int, completion:  @escaping (Result<[CharacterResult], MarvelError>) -> Void)
}
