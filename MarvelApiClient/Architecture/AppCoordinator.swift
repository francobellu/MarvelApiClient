//
//  AppCoordinator.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

// MARK: - Onboarding transitions handling

protocol OnboardingCoordinatorDelegate: class {
  func childCoordinatorDidFinish()
}

private enum AppCoordinatorState {
  case onboarding
  case landing

  static func next(dontShowOnboarding: Bool) -> AppCoordinatorState {
    switch dontShowOnboarding {
    case false: return .onboarding
    case true: return .landing
    }
  }
}

// This coordinator
class AppCoordinator: AppDependencyInjectable {
  var coordinatorPresenter: AnyObject?

  var coordinators = [Coordinator]()
  var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional
//  private var coordinator: (Coordinator)?
  private var state: AppCoordinatorState
  let navController = UINavigationController()

  init(presenter: UIWindow =  UIWindow(frame: UIScreen.main.bounds),
       dependencies: AppDependenciesProtocol) {

    self.coordinatorPresenter = presenter
    self.dependencies = dependencies
    self.state = AppCoordinatorState.next(dontShowOnboarding: dependencies.appConfig.dontShowOnboardingValue)
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
      let nextState = AppCoordinatorState.next(dontShowOnboarding: appConfig.dontShowOnboardingValue)
      runFlowfor(state: nextState)
    }

    func start(with option: DeepLinkOption?) { // swiftlint:disable:this function_body_length
       print("FB:AppCoordinator:start(with: \(String(describing: option))")
        //start with deepLink
        if let option = option {
            switch option {
            case .onboarding: runOnboardingFlow()
            case .landing: runLandingFlow()
            case .character, .characters:
              present(viewController: navController)
              let coordinator = CharactersListCoordinator(parentCoordinator: self, coordinatorPresenter: navController, dependencies: dependencies)
              add(coordinator)
              let deeplinkableCoord = coordinator
              deeplinkableCoord.start(with: option)
            case .comics, .comic:
//              present(viewController: navController)
//              let coordinator = ComicsListCoordinator(parentCoordinator: self, coordinatorPresenter: navController, dependencies: dependencies)
//              add(coordinator)
//              let deeplinkableCoord = coordinator
//              deeplinkableCoord.start(with: option)
              break
          }
          //default start
        } else {
          doStart()
      }
    }

  // MARK: - FLOWS
  private func runOnboardingFlow() {
    // No child coordinator. Just set the rootViewController directly injecting the finishFlow
    let presenter = OnboardingPresenter(dependencies: dependencies, coordinatorDelegate: self)

    let viewController = OnboardingViewController.instantiateViewController()
    viewController.presenter = presenter

    present(viewController: viewController)
  }

  private func runLandingFlow() {
    let coordinator = LandingCoordinator(parentCoordinator: self, presenter: navController, dependencies: dependencies)
    add(coordinator)
    coordinator.start()
    guard let presenter = coordinator.coordinatorPresenter as? UIViewController else { return }
    present(viewController: presenter )
  }

  // MARK: - HELPER METHODS
  private func present( viewController: UIViewController) {
    guard let coordinatorPresenter = coordinatorPresenter as? UIWindow  else { return }
    coordinatorPresenter.rootViewController = viewController
    coordinatorPresenter.makeKeyAndVisible()
  }

  private func runFlowfor(state: AppCoordinatorState) {
    switch state {
    case .onboarding: runOnboardingFlow()
    case .landing: runLandingFlow()
    }
  }
}

// MARK: - VC transitions handling

extension AppCoordinator: OnboardingCoordinatorDelegate {
  func childCoordinatorDidFinish() {
    runFlowfor(state: .landing)
  }
}
