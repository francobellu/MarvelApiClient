//
//  ComicViewController.swift
//  ApiLayer
//
//  Created by BELLU Franco on 25/10/2018.
//  Copyright © 2018 BELLU Franco. All rights reserved.
//

import UIKit

class ComicsListViewController: UIViewController, StoryboardInstantiable, AppDependencyInjectable {

  var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional
  var apiClient: MarvelAPIProtocol {
    dependencies.marvelApiClient
  }
  var comic: ComicResult?
  weak var coordinatorDelegate: ComicsCoordinatorDelegate! //swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    super.viewDidLoad()
    apiClient.getComic(with: 61537) { ( comic: ComicResult)  in
      // Update dataSOurce comics
      self.comic = comic
      print(comic)
    }
  }

//  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//      // Read the view controller we’re moving from.
//      guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
//          return
//      }
//
//      // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
//      if navigationController.viewControllers.contains(fromViewController) {
//          return
//      }
//
//      // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
//      if let buyViewController = fromViewController as? BuyViewController {
//          // We're popping a buy view controller; end its coordinator
//          childDidFinish(buyViewController.coordinator)
//      }
//  }

 @IBAction func n61537(_ sender: Any) {
    coordinatorDelegate.n61537()
  }

  @IBAction func flow2Action(_ sender: Any) {
    //coordinatorDelegate.btn2Selected()
  }

  @IBAction func flow3Action(_ sender: Any) {
   // coordinatorDelegate.btn3Selected()
  }
}
