//
//  DataStore.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
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

/// set functions are private because only the T4F_API should modify the settings
class UserDefaultsDataStore: DataStoreProtocol {

  private let userDef = UserDefaults.standard

  func keyExists(_ key: String) -> Bool {
    let result =  self.userDef.value(forKey: key)
    if result == nil {
      return false
    } else {
      return true
    }
  }

  // MARK: Setters
  func setAny(key: String, value: Any) {
    userDef.set(value, forKey: key)
    userDef.synchronize()
  }

  func setString(key: String, value: String) {
    self.userDef.set(value, forKey: key)
    self.userDef.synchronize()
  }

  func setBool(key: String, value: Bool) {
    self.userDef.set(value, forKey: key)
    self.userDef.synchronize()
  }

  // MARK: Getters

  func getAny(_ key: String)-> Any? {
    return self.userDef.value(forKey: key)
  }

  func getString(_ key: String, defaultValue: String = "") -> String {
    let result =  self.userDef.value(forKey: key)
    if result == nil {
      self.userDef.string(forKey: key)
      self.userDef.synchronize()
      return defaultValue
    } else {
      return result as! String
    }
  }

  func getBool(_ key: String, defaultValue: Bool = false) -> Bool {
    let result =  self.userDef.value(forKey: key)
    if result == nil {
      self.userDef.bool(forKey: key)
      self.userDef.synchronize()
      return defaultValue
    } else {
      return result as! Bool
    }
  }
}
