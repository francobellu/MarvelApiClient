//
//  LandingViewModel.swift
//  MarvelApiClient
//
//  Created by franco bellu on 16/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class LandingViewModel {

  private weak var coordinatorDelegate: LandingCoordinatorDelegate! //swiftlint:disable:this implicitly_unwrapped_optional

  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional
  
  private(set) var title = "Marvel Api Client"

  init(dependencies: AppDependencies, coordinatorDelegate: LandingCoordinatorDelegate) {
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
  }

  func didPressCharactersFlowAction() {
    coordinatorDelegate.charactersFlowActionSelected()
  }

  func didPressComicsFlowAction() {
    coordinatorDelegate.comicsFlowActionSelected()
  }

  func didPressAvengersComicsFlowAction() {
    coordinatorDelegate.avengersComicsFlowActionSelected()
  }

}
