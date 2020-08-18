//
//  DataStoreProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol DataStoreProtocol {
  func getAny(_ key: String)-> Any?
  func getString(_ key: String, defaultValue: String) -> String
  func getBool(_ key: String, defaultValue: Bool) -> Bool

  func setAny(key: String, value: Any)
  func setString(key: String, value: String)
  func setBool(key: String, value: Bool)
}
