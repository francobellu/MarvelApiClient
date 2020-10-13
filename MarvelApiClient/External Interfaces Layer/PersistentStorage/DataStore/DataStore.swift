//
//  DataStoreProtocol.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol DataStore {
  func getData(_ key: String)-> Data?
  func getString(_ key: String, defaultValue: String) -> String
  func getBool(_ key: String, defaultValue: Bool) -> Bool

  func setData(key: String, data: Data)
  func setString(key: String, value: String)
  func setBool(key: String, value: Bool)
}
