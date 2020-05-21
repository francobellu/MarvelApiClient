//
//  LandingCoordinator.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

protocol LandingCoordinatorDelegate: class {
  func charactersFlowActionSelected()
  func comicsFlowActionSelected()
}

//protocol ComicsListCoordinatorDelegate: class {
//  func btn1Selected()
//  func btn2Selected()
//  func btn3Selected()
//  func didGoBack()
//}
class LandingCoordinator: NSObject {

  // MARK: - Internal Dependencies
  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional
  //private var landingViewController: LandingViewController

  var coordinatorPresenter: AnyObject?

  // MARK: - Coordinator
  internal var coordinators: [Coordinator] = []
  weak var parentCoordinator: AppCoordinator?

  init(parentCoordinator: AppCoordinator, presenter: UINavigationController = UINavigationController(), dependencies: AppDependenciesProtocol ) {
    print("FB:LandingCoordinator:init()")
    self.parentCoordinator = parentCoordinator
    self.coordinatorPresenter = presenter

    self.dependencies = dependencies
    super.init()
  }
}

// MARK: - CoordinatorViewController
extension LandingCoordinator: Coordinator {

  func start() {
    showLanding()
  }

  func showLanding() {
    print("FB:LandingCoordinator:start()")
    let presenter = LandingPresenter(dependencies: dependencies, coordinatorDelegate: self)

    let viewController = LandingViewController.instantiateViewController()
    viewController.presenter = presenter
    print("FB:  Created VC: \(viewController) ")

    print("FB:  Presenting VC: \(viewController) ")
    present(viewController: viewController)
  }

  // MARK: - VC transitions handling
  private func present(viewController: UIViewController) {
    (coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}

extension LandingCoordinator: LandingCoordinatorDelegate {

  func charactersFlowActionSelected() {
    self.showAllCharacters()
  }

  func comicsFlowActionSelected() {
    self.showAllComics()
  }

  // MARK: - UTILITY FUNCTIONS
  private func  showAllCharacters() {
    // Create new coordinator...
    let charactersListCoordinator = CharactersListCoordinator(parentCoordinator: self, coordinatorPresenter: coordinatorPresenter as! UINavigationController, dependencies: dependencies)
    charactersListCoordinator.parentCoordinator = self
    // ...start it...
    charactersListCoordinator.start()
    // ...and add it
    add(charactersListCoordinator)
  }

  private func showAllComics() {
    // Create new coordinator...
    let comicsCoordinator = ComicsListCoordinator(parentCoordinator: self, coordinatorPresenter: coordinatorPresenter as! UINavigationController, dependencies: dependencies)
    comicsCoordinator.parentCoordinator = self
    // ...start it...
    comicsCoordinator.start()
    // ...and add it
    add(comicsCoordinator)
  }
}
