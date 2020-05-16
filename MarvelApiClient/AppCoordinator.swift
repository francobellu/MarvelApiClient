//
//  AppCoordinator.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

// TODO initial state
struct AppConfig {
  var dontShowOnboarding = false
  var isAutorized = true
  var isSkipped = false

  init() {
    let dataStore = UserDefaultsDataStore()
    dontShowOnboarding = dataStore.getBool("dontShowOnboarding")
  }
}

// MARK: - Onboarding transitions handling

// Handle the transitions of the child coordinators/viewcontrokllers
protocol OnboardingTransitionsProtocol: class {
  func childCoordinatorDidFinish()
}

private enum AppCoordinatorState {
  case onboarding
  case auth
  case landing

  static func next(dontShowOnboarding: Bool, isAutorized: Bool) -> AppCoordinatorState {
    switch (dontShowOnboarding, isAutorized) {
    case (true, false): return .auth
    case (false, true), (false, false): return .onboarding
    case (true, true): return .landing
    }
  }
}

// This coordinator
class AppCoordinator: AppDependencyInjectable {
  var presenter: AnyObject?

  var coordinators = [Coordinator]()
  var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional
  private var coordinator: (Coordinator)?
  private var state: AppCoordinatorState

  init(presenter: UIWindow =  UIWindow(frame: UIScreen.main.bounds),
       dependencies: AppDependencies) {

    self.presenter = presenter
    self.dependencies = dependencies
    self.state = AppCoordinatorState.next(dontShowOnboarding: dependencies.appConfig.dontShowOnboarding, isAutorized: dependencies.appConfig.isAutorized)
  }
}

extension AppCoordinator: Coordinator {
  func start() {
      print("FB:AppCoordinator:start()")
      doStart()
    }

    private func doStart() {
      print("FB:AppCoordinator:doStart()")
      let appConfig = dependencies.appConfig
      let nextState = AppCoordinatorState.next(dontShowOnboarding: appConfig.dontShowOnboarding,
                                               isAutorized: appConfig.isAutorized)
      runFlowfor(state: nextState)
    }

    func start(with option: DeepLinkOption?) { // swiftlint:disable:this function_body_length
       print("FB:AppCoordinator:start(with: \(String(describing: option))")
        //start with deepLink
        if let option = option {
            switch option {
            case .onboarding: runOnboardingFlow()
            case .landing: runLandingFlow()
            case .character:
              let navController = UINavigationController()
              present(viewController: navController)
              coordinator = CharactersListCoordinator(parentCoordinator: self, presenter: navController, dependencies: dependencies)
              let deeplinkableCoord = coordinator as? DeepLinkable
              deeplinkableCoord?.start(with: option)
            case .comic:
              let navController = UINavigationController()
              present(viewController: navController)
              coordinator = ComicsListCoordinator(parentCoordinator: self, presenter: navController, dependencies: dependencies)
              let deeplinkableCoord = coordinator as? DeepLinkable
              deeplinkableCoord?.start(with: option)
          }
          //default start
        } else {
          doStart()
      }
    }

  // MARK: - FLOWS
  private func runOnboardingFlow() {
    // No child coordinator. Just set the rootViewController directly injecting the finishFlow

    let viewController = OnboardingViewController.instantiateViewController()
    dependencies.inject(into: viewController)

    viewController.coordinatorDelegate = self
    present(viewController: viewController)
  }

  private func runLandingFlow() {
    coordinator = LandingCoordinator(parentCoordinator: self, presenter: UINavigationController(), dependencies: dependencies)
    coordinator?.start() // TODO: can it be inside constructor?
    guard let presenter = coordinator?.presenter else { return }
    present(viewController: presenter as! UIViewController) // swiftlint:disable:this force_cast
  }

  private func runAuthFlow() {
  }

  // MARK: - HELPER METHODS
  private func present( viewController: UIViewController) {
    // Present the ViewController
    //presenter.rootViewController = UIHostingController(rootView: OnboardingView())
    (presenter as! UIWindow).rootViewController = viewController // swiftlint:disable:this force_cast
    presenter?.makeKeyAndVisible()
  }

  private func runFlowfor(state: AppCoordinatorState) {
    switch state {
    case .onboarding: runOnboardingFlow()
    case .auth: runAuthFlow()
    case .landing: runLandingFlow()
    }
  }
}

extension AppCoordinator: OnboardingTransitionsProtocol {
  func childCoordinatorDidFinish() {
    // Free coordinator if existing
    if self.coordinator != nil { self.coordinator = nil }
    // Start next coordinator
    dependencies.appConfig.isSkipped = true
    start()
  }
}
