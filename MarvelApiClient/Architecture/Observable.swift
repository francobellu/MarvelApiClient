//
//  Observable.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation


class Observable<T> {
  var completion: (() -> Void)?
  var value: T {
    didSet {
      DispatchQueue.main.async {
        self.valueChanged?(self.value)
        self.completion?()
      }
    }
  }
  var valueChanged: ((T) -> Void)?

  init(value: T) {
    self.value = value
  }
}
