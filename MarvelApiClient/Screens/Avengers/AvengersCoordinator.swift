//
//  AvengersCoordinator.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

protocol AvengersListTransitionsProtocol: class {
  func btn1Selected()
  func btn2Selected()
  func btn3Selected()
  func didGoBack()
}

class AvengersCoordinator: Coordinator, AvengersListTransitionsProtocol {
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  var presenter: AnyObject?

  init(parentCoordinator: Coordinator, presenter: UINavigationController, dependencies: AppDependencies) {
    self.parentCoordinator = parentCoordinator
    self.presenter = presenter
  }

  func start() {
    print("FB:AvengersCoordinator:start()")
    let viewController = AvengersViewController.instantiateViewController()
    viewController.title = "Avengers Detail"

    print("FB:  Created VC: \(viewController) ")
    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  func btn1Selected() {

  }

  func btn2Selected() {

  }

  func btn3Selected() {

  }

  func didGoBack() {
    parentCoordinator?.disposeChild(coordinator: self)
  }
}