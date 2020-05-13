//
//  ComicsListVcCoordinator.swift
//  ApiLayer
//
//  Created by BELLU Franco on 25/10/2018.
//  Copyright © 2018 BELLU Franco. All rights reserved.
//

import UIKit

protocol ComicsListTransitionsProtocol: class {
  func btn1Selected()
  func btn2Selected()
  func btn3Selected()
  func didGoBack()
}

class ComicsListVcCoordinator: Coordinator, AppDependencyInjectable, ComicsListTransitionsProtocol {

  var presenter: UIViewController?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  weak var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  init(parentCoordinator: Coordinator, dependencies: AppDependencies) {
    print("FB:ComicsListVcCoordinator:init()")
    self.dependencies = dependencies
    self.presenter = parentCoordinator.presenter
    self.parentCoordinator = parentCoordinator
  }

  func start() {
    print("FB:ComicsListVcCoordinator:start()")
    let comicsListViewController = ComicsListViewController.instantiateViewController()
    comicsListViewController.dependencies = dependencies
    comicsListViewController.title = "Comics List"
    (presenter as? UINavigationController)?.pushViewController(comicsListViewController, animated: true)
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
