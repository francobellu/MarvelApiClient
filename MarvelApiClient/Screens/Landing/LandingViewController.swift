//
//  LandingViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, StoryboardInstantiable {
  var viewModel: LandingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    super.viewDidLoad()
    title = viewModel.title
  }

  @IBAction func charactersFlowAction(_ sender: Any) {
    viewModel.didPressCharactersFlowAction()
  }

  @IBAction func comicsFlowAction(_ sender: Any) {
    viewModel.didPressComicsFlowAction()
  }

  @IBAction func avengersComicsFlowAction(_ sender: Any) {
    viewModel.didPressAvengersComicsFlowAction()
  }
}
