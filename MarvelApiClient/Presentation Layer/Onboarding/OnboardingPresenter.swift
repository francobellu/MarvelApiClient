//
//  OnboardingPresenter.swift
//  MarvelApiClient
//
//  Created by franco bellu on 16/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class OnboardingPresenter {

  private(set) var title = "Character Detail"

  private var dependencies: AppDIContainerProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private weak var coordinatorDelegate: OnboardingCoordinatorDelegate! // swiftlint:disable:this implicitly_unwrapped_optional

  init(dependencies: AppDIContainerProtocol, coordinatorDelegate: OnboardingCoordinatorDelegate) {
    print("FB:OnboardingPresenter:init()")
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
  }

  /// - Returns: The image name corresponding to the new State
  func didPressDontShowAgain() -> String {
    let value = dependencies.appSettings.dontShowOnboardingValue
    let newValue = !value
    dependencies.appSettings.dontShowOnboardingValue = newValue
    return newValue == false ? "rectangle" : "checkmark.rectangle.fill"
  }

  func getImageStrDontShowAgainBtnToogle() -> String {
    let value = dependencies.appSettings.dontShowOnboardingValue
    let newValue = !value
    dependencies.appSettings.dontShowOnboardingValue = newValue
    return newValue == false ? "rectangle" : "checkmark.rectangle.fill"
  }

  func getImageStrDontShowAgainBtn() -> String {
    let value = dependencies.appSettings.dontShowOnboardingValue
    return value == false ? "rectangle" : "checkmark.rectangle.fill"
  }

  func didPressSkipAction() {
    coordinatorDelegate.childCoordinatorDidFinish()
  }
}
