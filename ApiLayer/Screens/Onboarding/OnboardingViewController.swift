//
//  OnboardingViewController.swift
//  ApiLayer
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit
import SwiftUI

struct OnboardingView: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> OnboardingViewController {
    let onboardingVC = OnboardingViewController.instantiateViewController()
    return onboardingVC
  }

  func updateUIViewController(_ uiViewController: OnboardingViewController, context: Context) {

  }
}

class OnboardingViewController: UIViewController, StoryboardInstantiable, AppDependencyInjectable {
  var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional
  var onboardingWasShown: Bool = true
  @IBOutlet weak var dontShowAgainBtn: UIButton!
  var dontShowAgain = false
  weak var coordinatorDelegate: OnboardingTransitionsProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func skipAction(_ sender: Any) {
    coordinatorDelegate.childCoordinatorDidFinish()
  }

  @IBAction func dontShowAgain(_ sender: Any) {
    dontShowAgain.toggle()
    changeButtonImage()
    dependencies.dataStore.setBool(key: "dontShowOnboarding", value: dontShowAgain)
    print("OnboardingViewController:dontShowAgain()")
  }

  private func changeButtonImage() {
    let btnImageName = dontShowAgain == false ? "rectangle" : "checkmark.rectangle.fill"
    let btnImage = UIImage(systemName: btnImageName)
    dontShowAgainBtn.setImage(btnImage, for: .normal)
  }
}
