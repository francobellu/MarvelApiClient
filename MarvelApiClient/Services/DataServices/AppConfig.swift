//
//  AppConfig.swift
//  MarvelApiClient
//
//  Created by franco bellu on 17/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

public enum MarvelPreferenceKeys: String {
  case dontShowOnboarding
}

class AppConfig {
  let store: DataStoreProtocol = UserDefaultsDataStore()
  var dontShowOnboardingValue: Bool  {
    get {
      store.getBool(MarvelPreferenceKeys.dontShowOnboarding.rawValue, defaultValue: false)
    }
    set (newValue){
      store.setBool(key: MarvelPreferenceKeys.dontShowOnboarding.rawValue, value: newValue)
    }
  }
}
