//
//  CharactersListCoordinator.swift
//  ApiLayer
//
//  Created by BELLU Franco on 25/10/2018.
//  Copyright © 2018 BELLU Franco. All rights reserved.
//

import UIKit

protocol CharactersListViewcoordinatorDelegate: class {
  func goBack()
  func didSelect(character: ComicCharacter)
}

class CharactersListCoordinator: NSObject, AppDependencyInjectable {

  var presenter: UIViewController?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  init(parentCoordinator: Coordinator, dependencies: AppDependencies) {
    print("FB:CharactersListCoordinator:init()")
    self.dependencies = dependencies
    self.parentCoordinator = parentCoordinator
    self.presenter = parentCoordinator.presenter
    super.init()
  }

  deinit {
    print("FB:CharactersListCoordinator:deinit()")
  }
}

extension CharactersListCoordinator: Coordinator {

  func start() {
    print("FB:CharactersListCoordinator:start()")
    presentViewController()
  }

  private func presentViewController() {
    let viewController = CharactersListViewController.instantiateViewController()
    viewController.coordinatorDelegate = self
    print("FB:  Created VC: \(viewController) ")

    // Inject the ViewModel
    let viewModel = CharactersListViewModel(dependencies: dependencies)
    viewController.viewModel = viewModel
    print("FB:  Presenting VC: \(viewController) ")
    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}

// MARK: - VC transitions
extension CharactersListCoordinator: CharactersListViewcoordinatorDelegate {
  func goBack() {
    print("FB:CharactersListCoordinator:goBack()")
    print("FB:  popVC")
    guard let navigationController = presenter as? UINavigationController else { return }
    navigationController.popViewController(animated: true)
    parentCoordinator?.disposeChild(coordinator: self)
  }

  func didSelect(character: ComicCharacter) {
    // Destination doesn't need coordination, just present the VC
    let characterDetailVc = CharacterDetailViewController.instantiateViewController()
    characterDetailVc.character = character
    characterDetailVc.title = "Character Detail"
    (presenter as? UINavigationController)?.pushViewController(characterDetailVc, animated: true)
  }
}
