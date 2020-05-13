//
//  LandingViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, StoryboardInstantiable {
  weak var coordinatorDelegate: LandingTransitionProtocol! //swiftlint:disable:this implicitly_unwrapped_optional
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Marvel Api Client"
  }

  @IBAction func flow1Action(_ sender: Any) {
    coordinatorDelegate.btn1Selected()
  }

  @IBAction func flow2Action(_ sender: Any) {
    coordinatorDelegate.btn2Selected()
  }

  @IBAction func flow3Action(_ sender: Any) {
    coordinatorDelegate.btn3Selected()
  }

  /// this technics loses the swipe right gesture to go back!!!
  func setBackBtnInterceptMechanism() {

    // Disable the swipe to make sure you get your chance to save
    guard let navigationController = self.navigationController else { return }
    navigationController.interactivePopGestureRecognizer?.isEnabled = false

    // Replace the default back button with one which we can intercpt the action
    navigationItem.setHidesBackButton(true, animated: false)
    let backButton = UIBarButtonItem(title: "Back",
                                     style: UIBarButtonItem.Style.plain,
                                     target: self,
                                     action: #selector(goBack))
    navigationItem.leftBarButtonItem = backButton
  }

  // Then handle the button selection
  @objc func goBack() {
    // Here we just remove the back button, you could also disabled it or better yet show an activityIndicator
    self.navigationItem.leftBarButtonItem = nil
    let allowGoBack = true
    if allowGoBack {
      // Don't forget to re-enable the interactive gesture
      self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
      coordinatorDelegate.goBack()
    } else {
      //self.navigationItem.leftBarButtonItem = backButton
      // Handle the error
    }
  }
}
