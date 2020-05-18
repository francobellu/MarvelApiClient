//
//  OnboardingViewMovel.swift
//  MarvelApiClient
//
//  Created by franco bellu on 16/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class OnboardingViewModel {

  private(set) var title = "Character Detail"

  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  private weak var coordinatorDelegate: OnboardingCoordinatorDelegate! // swiftlint:disable:this implicitly_unwrapped_optional

  init(dependencies: AppDependencies, coordinatorDelegate: OnboardingCoordinatorDelegate){
    print("FB:OnboardingViewModel:init()")
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
  }

  /// - Returns: The image name corresponding to the new State
  func didPressDontShowAgain() -> String{
    let value = dependencies.appConfig.dontShowOnboardingValue
    let newValue = !value
    dependencies.appConfig.dontShowOnboardingValue = newValue
    return newValue == false ? "rectangle" : "checkmark.rectangle.fill"
  }

  func getImageStrDontShowAgainBtnToogle() -> String{
    let value = dependencies.appConfig.dontShowOnboardingValue
    let newValue = !value
    dependencies.appConfig.dontShowOnboardingValue = newValue
    return newValue == false ? "rectangle" : "checkmark.rectangle.fill"
  }

  func getImageStrDontShowAgainBtn() -> String{
    let value = dependencies.appConfig.dontShowOnboardingValue
    return value == false ? "rectangle" : "checkmark.rectangle.fill"
  }

  func didPressSkipAction() {
    coordinatorDelegate.childCoordinatorDidFinish()
  }
}
