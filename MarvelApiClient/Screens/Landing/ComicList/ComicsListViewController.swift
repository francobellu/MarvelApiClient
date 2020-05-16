//
//  ComicViewController.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2010.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class ComicsListViewController: UIViewController, StoryboardInstantiable {
  var viewModel: ComicsListViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = viewModel.title
    tableView.dataSource = self
    tableView.delegate = self
    setBackBtnInterceptMechanism()
    tableView.register(UINib(nibName: R.nib.comicCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.comicCellId.identifier)
    viewModel.getComicsList {
      // Reload Data
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
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
      viewModel.didGoBack()
    }
  }
}

extension ComicsListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.comicsCount()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let newComic = viewModel.getComic(at: indexPath.row)
    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.comicCellId.identifier) as?
      ComicCell else { return UITableViewCell() }

    cell.config(with: newComic)
    // Check if the last row number is the same as the last current data element
    if indexPath.row == viewModel.comicsCount() - 1 {
      viewModel.getNextComicsList  {
        DispatchQueue.main.async {
          tableView.reloadData()
        }
      }
    }
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
}

extension ComicsListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let comic = viewModel.getComic(at: indexPath.row)
    viewModel.didSelect(comic: comic)
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
