//
//  ComicDetailViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//
import UIKit

class ComicDetailViewController: UIViewController, StoryboardInstantiable {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var details: UILabel!
  @IBOutlet weak var idLabel: UILabel!

  var viewModel: ComicDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  weak var coordinatorDelegate: ComicsListCoordinatorDelegate! //swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    guard let comic = viewModel.comic else { return }
    title = viewModel.title
    set(comic: comic)
    super.viewDidLoad()
    }

    func set(comic: ComicResult) {
      self.titleLabel.text = comic.title
      guard let thumbnail = comic.thumbnail else { return  }
      self.thumbnailView.af.setImage(withURL: thumbnail.url)
      self.details.text = comic.resultDescription
      self.idLabel.text = String(describing: comic.id)
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

}
