//
//  ComicsCoordinator.swift
//  ApiLayer
//
//  Created by BELLU Franco on 25/10/2018.
//  Copyright © 2018 BELLU Franco. All rights reserved.
//

import UIKit

protocol ComicsCoordinatorDelegate: class {
  func n61537()
  func didGoBack()
}

class ComicsCoordinator: AppDependencyInjectable {

  var presenter: AnyObject?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  weak var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional
  var comic: ComicResult!

  init(parentCoordinator: Coordinator, presenter: UINavigationController, dependencies: AppDependencies) {
    print("FB:ComicsCoordinator:init()")
    self.dependencies = dependencies
    self.presenter = presenter
    self.parentCoordinator = parentCoordinator
  }
}

extension ComicsCoordinator: Coordinator {
  func start() {
    print("FB:ComicsCoordinator:start()")
    startComicsListViewController()
  }
  func startComicsListViewController() {
    print("FB:ComicsCoordinator:startComicsListViewController()")
    let comicsListViewController = ComicsListViewController.instantiateViewController()
    dependencies.inject(into: comicsListViewController)
    comicsListViewController.coordinatorDelegate = self
    //comicsListViewController.title = comic?.title
    (presenter as? UINavigationController)?.pushViewController(comicsListViewController, animated: true)
  }

  func startComicViewCOntroller() {
    print("FB:ComicsCoordinator:startComicViewCOntroller()")
    let comicViewController = ComicViewController.instantiateViewController()
    dependencies.inject(into: comicViewController)
    comicViewController.coordinatorDelegate = self
    comicViewController.title = comic?.title
    (presenter as? UINavigationController)?.pushViewController(comicViewController, animated: true)
  }
}

extension ComicsCoordinator: ComicsCoordinatorDelegate {
  func n61537() {
    print("FB:ComicsCoordinator:n61537()")
  }

  func didGoBack() {
    parentCoordinator?.disposeChild(coordinator: self)
  }
}
