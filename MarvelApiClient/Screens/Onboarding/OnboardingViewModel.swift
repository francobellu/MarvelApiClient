//
//  OnboardingViewMovel.swift
//  MarvelApiClient
//
//  Created by franco bellu on 16/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class OnboardingViewModel {

  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  weak var coordinatorDelegate: OnboardingCoordinatorDelegate! // swiftlint:disable:this implicitly_unwrapped_optional

  private(set) var title = "Character Detail"

  // STATE
  private var dontShowAgain = false

  init(dependencies: AppDependencies ){
    print("FB:OnboardingViewModel:init()")
    self.dependencies = dependencies
  }

  /// - Returns: The image name corresponding to the new State
  func didPressDontShowAgain() -> String{
    let value = dependencies.appConfig.dontShowOnboardingValue
    let newValue = !value
    dependencies.appConfig.dontShowOnboardingValue = newValue
    return newValue == false ? "rectangle" : "checkmark.rectangle.fill"
  }

  func didPressSkipAction() {
    coordinatorDelegate.childCoordinatorDidFinish()
  }
}
