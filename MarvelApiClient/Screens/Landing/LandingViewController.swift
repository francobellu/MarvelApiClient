//
//  LandingViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, StoryboardInstantiable {
  weak var coordinatorDelegate: LandingCoordinatorDelegate! //swiftlint:disable:this implicitly_unwrapped_optional

  var viewModel: LandingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
  override func viewDidLoad() {
    super.viewDidLoad()
    title = viewModel.title
  }

  @IBAction func charactersFlowAction(_ sender: Any) {
    coordinatorDelegate.charactersFlowActionSelected()
  }

  @IBAction func comicsFlowAction(_ sender: Any) {
    coordinatorDelegate.comicsFlowActionSelected()
  }

  @IBAction func avengersComicsFlowAction(_ sender: Any) {
    coordinatorDelegate.avengersComicsFlowActionSelected()
  }
}
