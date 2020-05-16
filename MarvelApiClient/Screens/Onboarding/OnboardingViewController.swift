//
//  OnboardingViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, StoryboardInstantiable {
  var viewModel: OnboardingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  @IBOutlet weak var dontShowAgainBtnAction: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func skipAction(_ sender: Any) {
    viewModel.didPressSkipAction()
  }

  @IBAction func dontShowAgain(_ sender: Any) {
    print("OnboardingViewController:dontShowAgain()")
    let btnImageName = viewModel.didPressDontShowAgain()
    dontShowAgainBtnAction.setImage(UIImage(systemName: btnImageName), for: .normal)
  }
}
