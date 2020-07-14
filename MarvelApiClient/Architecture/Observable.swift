//
//  Observable.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation


class Observable<T> {
  var value: T {
    didSet {
      print("FB value did set: \(value)")
      DispatchQueue.main.async {
        self.valueChanged?(self.value)
      }
    }
  }
  var valueChanged: ((T) -> Void)?

  init(value: T) {
    self.value = value
  }
}
