//
//  ComicDetailViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//
import UIKit
import AlamofireImage

class ComicDetailViewController: UIViewController, StoryboardInstantiable {
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var seriesLabel: UILabel!

//  @IBOutlet weak var scrollView: UIScrollView!
  var viewModel: ComicDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
//    scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)

    configureView()
    super.viewDidLoad()
  }

  func configureView() {
    guard let comic = viewModel.comic else { return }
    title = viewModel.getName()

    guard let thumbnail = comic.thumbnail else { return  }
    thumbnailView.af.setImage(withURL: thumbnail.url)

    descriptionLabel.text = viewModel.getDescription()
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping

    seriesLabel.text = viewModel.getSeries()
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
