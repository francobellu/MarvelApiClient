//
//  ComicsLISTCoordinator.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

protocol ComicsListCoordinatorDelegate: class {
  func didGoBack()
  func didSelect(comic: ComicResult)
}

class ComicsListCoordinator: AppDependencyInjectable {

  var presenter: AnyObject?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  weak var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  init(parentCoordinator: Coordinator, presenter: UINavigationController, dependencies: AppDependencies) {
    print("FB:ComicsListCoordinator:init()")
    self.dependencies = dependencies
    self.presenter = presenter
    self.parentCoordinator = parentCoordinator
  }
}

extension ComicsListCoordinator: Coordinator {
  func start() {
    print("FB:ComicsListCoordinator:start()")
    presentComicsListViewController()
  }

  func start(with option: DeepLinkOption?) {
    print("FB:ComicsListCoordinator:start(with: \(String(describing: option))")
        //start with deepLink
    if case .comic(let id) = option {
      guard let id = id else { fatalError()}
      presentComicDetailViewController(with: id)
    }
  }

  private func presentComicsListViewController() {
    print("FB:ComicsListCoordinator:startComicsListViewController()")

    let viewModel = ComicsListViewModel(dependencies: dependencies)
    viewModel.coordinatorDelegate = self

    let viewController = ComicsListViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentComicDetailViewController(with comicId: String ) {
    print("FB:ComicsListCoordinator:startComicViewCOntroller()")
    let viewModel = ComicDetailViewModel(dependencies: dependencies, comicId: comicId)

    let viewController = ComicDetailViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}

// MARK: - VC transitions handling
extension ComicsListCoordinator: ComicsListCoordinatorDelegate {
  func didGoBack() {
    print("FB: ComicsListCoordinator:goBack()")
    print("FB:  popVC")
    guard let navigationController = presenter as? UINavigationController else { return }
    navigationController.popViewController(animated: true)
    parentCoordinator?.disposeChild(coordinator: self)
  }

  func didSelect(comic: ComicResult) {
      // Destination doesn't need coordination, just present the VC
      presentComicDetailViewController(with: comic)
  }

  private func presentComicDetailViewController(with comic: ComicResult ) {
    let viewModel = ComicDetailViewModel(dependencies: dependencies, comic: comic)
    let viewController = ComicDetailViewController.instantiateViewController()
    viewController.viewModel = viewModel
    //viewController.coordinatorDelegate = self
    print("FB:  Created VC: \(viewController) ")
    print("FB:  Presenting VC: \(viewController) ")
    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}
