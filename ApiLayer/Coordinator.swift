//
//  Coordinator.swift
//  ApiLayer
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import UIKit

// NEEDS TO BE A CLASS PROTOCOL BECAUSE THE DELEGATE NEEDS TO BE STORED AS A REFERENCE TYPE
protocol Coordinator: class {
  var coordinators: [Coordinator] { get set}

  var presenter: AnyObject? { get set}

  func disposeChild(coordinator: Coordinator)
  /// Set up a new coordinator or present a new view  ( if no coord needed)
  func start()
}

protocol DeepLinkable: class {
  func start(with option: DeepLinkOption?)
}

extension Coordinator {

  func disposeChild(coordinator: Coordinator) {
    remove(coordinator)
  }

  // add only unique object
  func add(_ coordinator: Coordinator) {

    for element in coordinators where element === coordinator {
      return
    }
    coordinators.append(coordinator)
  }

  func remove(_ coordinator: Coordinator?) {
    guard
      coordinators.isEmpty == false,
      let coordinator = coordinator
      else { return }

    for (index, element) in coordinators.enumerated() where element === coordinator {
      coordinators.remove(at: index)
      break
    }
  }
}
