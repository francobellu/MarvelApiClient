//
//  OnboardingCoordinator.swift
//  ApiLayer
//
//  Created by franco bellu on 10/04/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

//class OnboardingCoordinator: NSObject {
//
//  // MARK: - Internal Dependencies
//  private let factory: DependencyFactory
//  //private var landingViewController: LandingViewController
//
//  // MARK: - Coordinator
//  internal var coordinators: [Coordinator] = []
//  var presenter: UIViewController? = nil
//
//  init(factory: DependencyFactory) {
//    self.factory = factory
//    super.init()
//  }
//}
//
//// MARK: - CoordinatorViewController
//extension OnboardingCoordinator: Coordinator {
//  func start() {
//    let landingViewController = LandingViewController.instantiateViewController()
//    let transitions = LandingViewTransitions(btn1Selected: {
//      self.showAllCharacters()
//    }, btn2Selected: {
//      self.showAverngersComics()
//    }, btn3Selected:{
//      self.showComic()
//    })
//    landingViewController.transitions =  transitions
//
//    presenter = landingViewController
//  }
//}
//
//extension OnboardingCoordinator {
//  // MARK: - UTILITY FUNCTIONS
//  private func  showAllCharacters() {
//    // Create new coordinator...
//    let charactersListCoordinator = CharactersListCoordinator(parentCoordinator: self, factory: factory)
//    charactersListCoordinator.parentCoordinator = self
//    // ...start it...
//    charactersListCoordinator.start()
//    // ...and add it
//    add(charactersListCoordinator)
//  }
//
//  private func showAverngersComics() {
//    // Create new coordinator...
//    let comicsVcCoordinator = ComicsListVcCoordinator(parentCoordinator: self, factory: factory)
//    comicsVcCoordinator.parentCoordinator = self
//    // ...start it...
//    comicsVcCoordinator.start()
//    // ...and add it
//    add(comicsVcCoordinator)
//  }
//
//  private func showComic() {
//    // Create new coordinator...
//    let avengersViewController = AvengersViewController.instantiateViewController()
//
//    presenter.pushViewController(avengersViewController, animated: true)
//    avengersViewController.title = "Comic Detail"
//  }
//}
