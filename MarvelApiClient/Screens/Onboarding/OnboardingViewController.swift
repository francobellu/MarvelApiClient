//
//  OnboardingViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, StoryboardInstantiable {
  @IBOutlet weak var dontShowAgainBtnAction: UIButton!

  var viewModel: OnboardingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  weak var coordinatorDelegate: OnboardingCoordinatorDelegate! // swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func skipAction(_ sender: Any) {
    coordinatorDelegate.childCoordinatorDidFinish()
  }

  @IBAction func dontShowAgain(_ sender: Any) {
    print("OnboardingViewController:dontShowAgain()")
    let btnImageName = viewModel.didPressDontShowAgain()
    dontShowAgainBtnAction.setImage(UIImage(systemName: btnImageName), for: .normal)
  }
}
