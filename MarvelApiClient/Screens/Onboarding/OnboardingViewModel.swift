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

  // STATE
  private var dontShowAgain = false

  /// - Returns: The image name corresponding to the new State
  func didPressDontShowAgain() -> String{
    dontShowAgain.toggle()
    return dontShowAgain == false ? "rectangle" : "checkmark.rectangle.fill"
  }
}
