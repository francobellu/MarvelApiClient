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

class ComicsListCoordinator {

  var coordinatorPresenter: AnyObject?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  weak var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  init(parentCoordinator: Coordinator, coordinatorPresenter: UINavigationController, dependencies: AppDependenciesProtocol) {
    print("FB:ComicsListCoordinator:init()")
    self.dependencies = dependencies
    self.coordinatorPresenter = coordinatorPresenter
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
    switch option {
    case .comic(let id):
      guard let id = id else { fatalError()}
      presentComicDetailViewController(with: id)
    case .comics:
      presentComicsListViewController()
    default:
      return
    }
  }

  private func presentComicsListViewController() {
    print("FB:ComicsListCoordinator:startComicsListViewController()")

    let viewPresenter = ComicsListPresenter(dependencies: dependencies, coordinatorDelegate: self)

    let viewController = ComicsListViewController.instantiateViewController()
    viewController.presenter = viewPresenter

    (coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentComicDetailViewController(with comicId: String ) {
    let presenter = ComicDetailPresenter(dependencies: self.dependencies, comicId: comicId)
    DispatchQueue.global(qos: .background).async {
      guard let id = Int(comicId)  else {
        print("Invalid deepLink url")
        return
      }
      presenter.getComic(with: id) {
        DispatchQueue.main.sync {
          let viewController = ComicDetailViewController.instantiateViewController()
          viewController.presenter = presenter
          (self.coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
        }
      }
    }
  }
}

// MARK: - VC transitions handling
extension ComicsListCoordinator: ComicsListCoordinatorDelegate {
  func didGoBack() {
    print("FB: ComicsListCoordinator:goBack()")
    print("FB:  popVC")
    guard let navigationController = coordinatorPresenter as? UINavigationController else { return }
    if navigationController.viewControllers.count > 1 {
      navigationController.popViewController(animated: true)
      parentCoordinator?.disposeChild(coordinator: self)
    }
  }

  func didSelect(comic: ComicResult) {
      // Destination doesn't need coordination, just present the VC
      presentComicDetailViewController(with: comic)
  }

  private func presentComicDetailViewController(with comic: ComicResult ) {
    let viewPresenter = ComicDetailPresenter(dependencies: dependencies, comic: comic)
    let viewController = ComicDetailViewController.instantiateViewController()
    viewController.presenter = viewPresenter
    //viewController.coordinatorDelegate = self
    print("FB:  Created VC: \(viewController) ")
    print("FB:  Presenting VC: \(viewController) ")
    (coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}
