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
  func avengersComicsFlowActionSelected()
}

//protocol ComicsListCoordinatorDelegate: class {
//  func btn1Selected()
//  func btn2Selected()
//  func btn3Selected()
//  func didGoBack()
//}
class LandingCoordinator: NSObject, AppDependencyInjectable {

  // MARK: - Internal Dependencies
  var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional
  //private var landingViewController: LandingViewController

  var presenter: AnyObject?

  // MARK: - Coordinator
  internal var coordinators: [Coordinator] = []
  weak var parentCoordinator: AppCoordinator?

  init(parentCoordinator: AppCoordinator, presenter: UINavigationController = UINavigationController(), dependencies: AppDependencies ) {
    print("FB:LandingCoordinator:init()")
    self.parentCoordinator = parentCoordinator
    self.presenter = presenter

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
    let viewModel = LandingViewModel()

    let viewController = LandingViewController.instantiateViewController()
    viewController.viewModel = viewModel
    print("FB:  Created VC: \(viewController) ")
    viewController.coordinatorDelegate = self
    print("FB:  Presenting VC: \(viewController) ")
    present(viewController: viewController)
  }

  // MARK: - VC transitions handling
  private func present(viewController: UIViewController) {
    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}

extension LandingCoordinator: LandingCoordinatorDelegate {

  func charactersFlowActionSelected() {
    self.showAllCharacters()
  }

  func comicsFlowActionSelected() {
    self.showAllComics()
  }

  func avengersComicsFlowActionSelected() {
    self.showAverngersComics()
  }

  // MARK: - UTILITY FUNCTIONS
  private func  showAllCharacters() {
    // Create new coordinator...
    let charactersListCoordinator = CharactersListCoordinator(parentCoordinator: self, presenter: presenter as! UINavigationController, dependencies: dependencies)
    charactersListCoordinator.parentCoordinator = self
    // ...start it...
    charactersListCoordinator.start()
    // ...and add it
    add(charactersListCoordinator)
  }

  private func showAllComics() {
    // Create new coordinator...
    let comicsCoordinator = ComicsListCoordinator(parentCoordinator: self, presenter: presenter as! UINavigationController, dependencies: dependencies)
    comicsCoordinator.parentCoordinator = self
    // ...start it...
    comicsCoordinator.start()
    // ...and add it
    add(comicsCoordinator)
  }

  private func showAverngersComics() {
    // Create new coordinator...
    let avengersCoordinator = AvengersCoordinator(parentCoordinator: self, presenter: presenter as! UINavigationController, dependencies: dependencies)
    // ...start it...
    avengersCoordinator.start()
    // ...and add it
    add(avengersCoordinator)
  }
}
