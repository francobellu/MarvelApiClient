//
//  DataStore.swift
//  ApiLayer
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

public enum T4fPreferencesKeys: String {
  // MARK: Preferences Keys
  case KEY_PREFERENCES_LAUNCH_COUNTER
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

  init() {
//    loadDefaultSettingValues()
  }

//  func store(key: String, value: Any) {
//    if let boolValue = value as? Bool{
//      setBool(key: key, value: boolValue)
//    }else{
//    setAny(key: key, value: value)
//    }
//  }
//
//  func restore(_ key: String)-> Any? {
//    var value: Any
//    if
//    return getAny(key)
//  }

  private func doLoadDefaultSettingValues() {
    setBool(key: T4fPreferencesKeys.KEY_PREFERENCES_LAUNCH_COUNTER.rawValue, value: true)
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

  private func setInt(key: String, value: Int) {
    self.userDef.set(value, forKey: key)
    self.userDef.synchronize()
  }

  private func setFloat(key: String, value: Float) {
    self.userDef.set(value, forKey: key)
    self.userDef.synchronize()
  }

  private func setDouble(key: String, value: Double) {
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
      self.userDef.set(defaultValue, forKey: key)
      self.userDef.synchronize()
      return defaultValue
    } else {
      return result as! String
    }
  }

  func getBool(_ key: String, defaultValue: Bool = false) -> Bool {
    let result =  self.userDef.value(forKey: key)
    if result == nil {
      self.userDef.set(defaultValue, forKey: key)
      self.userDef.synchronize()
      return defaultValue
    } else {
      return result as! Bool
    }
  }
//
//  private func getInt(_ key: String, defaultValue: Int = 0) -> Int {
//    let result =  self.userDef.value(forKey: key)
//    if result == nil {
//      self.userDef.set(defaultValue, forKey: key)
//      self.userDef.synchronize()
//      return defaultValue
//    } else {
//      return result as! Int
//    }
//  }
//
//  private func getFloat(_ key: String, defaultValue: Float = 0) -> Float {
//    let result =  self.userDef.value(forKey: key)
//    if result == nil {
//      self.userDef.set(defaultValue, forKey: key)
//      self.userDef.synchronize()
//      return defaultValue
//    } else {
//      return result as! Float
//    }
//  }
//
//  private func getDouble(_ key: String, defaultValue: Double = 0) -> Double {
//    let result =  self.userDef.value(forKey: key)
//    if result == nil {
//      self.userDef.set(defaultValue, forKey: key)
//      self.userDef.synchronize()
//      return defaultValue
//    } else {
//      return result as! Double
//    }
  }

//  public func loadDefaultSettingValues() {
//
//    if !getBool(T4fPreferencesKeys.KEY_PREFERENCES_FIRST_CONFIG_DONE.rawValue) {
//      doLoadDefaultSettingValues()
//      setBool(key: T4fPreferencesKeys.KEY_PREFERENCES_FIRST_CONFIG_DONE.rawValue, value: true)
//    }
//  }
