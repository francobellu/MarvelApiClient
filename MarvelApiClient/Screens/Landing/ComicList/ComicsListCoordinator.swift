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
    switch option {
    case .comic(let id):
      guard let id = id else { fatalError()}
      presentComicDetailViewController(with: id)
    case .comics:
      presentComicsListViewController()
    default:
      return
    }
    if case .comic(let id) = option {
      guard let id = id else { fatalError()}
      presentComicDetailViewController(with: id)
    }
    if case .comics = option {
      presentComicsListViewController()
    }
  }

  private func presentComicsListViewController() {
    print("FB:ComicsListCoordinator:startComicsListViewController()")

    let viewModel = ComicsListViewModel(dependencies: dependencies, coordinatorDelegate: self)

    let viewController = ComicsListViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentComicDetailViewController(with comicId: String ) {
    let viewModel = ComicDetailViewModel(dependencies: self.dependencies, comicId: comicId)
    DispatchQueue.global(qos: .background).async{
      guard let id = Int(comicId)  else {
        print("Invalid deepLink url")
        return
      }
      viewModel.getComic(with: id){
        DispatchQueue.main.sync{
          let viewController = ComicDetailViewController.instantiateViewController()
          viewController.viewModel = viewModel
          (self.presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
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
    guard let navigationController = presenter as? UINavigationController else { return }
    if navigationController.viewControllers.count > 1{
      navigationController.popViewController(animated: true)
      parentCoordinator?.disposeChild(coordinator: self)
    }
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
