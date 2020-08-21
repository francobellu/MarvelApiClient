//
//  NetworkInterface.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

protocol MarvelApiProtocol {
  // Characters
  func getCharactersList(completion: @escaping (Result<[CharacterResult], RestServiceError>) -> Void)
  func getCharacter(with id: Int, completion:  @escaping (Result<[CharacterResult], RestServiceError>) -> Void)
}
