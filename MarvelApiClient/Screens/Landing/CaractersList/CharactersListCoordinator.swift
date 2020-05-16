//
//  CharactersListCoordinator.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

protocol CharactersListCoordinatorDelegate: class {
  func didGoBack()
  func didSelect(character: CharacterResult)
}

class CharactersListCoordinator: NSObject, AppDependencyInjectable {

  var presenter: AnyObject?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  init(parentCoordinator: Coordinator, presenter: UINavigationController, dependencies: AppDependencies) {
    print("FB:CharactersListCoordinator:init()")
    self.dependencies = dependencies
    self.parentCoordinator = parentCoordinator
    self.presenter = presenter
    super.init()
  }
}

extension CharactersListCoordinator: Coordinator, DeepLinkable {

  func start() {
    print("FB:CharactersListCoordinator:start()")
    presentCharactersListViewController()
  }

  func start(with option: DeepLinkOption?) {
    print("FB:CharactersListCoordinator:start(with: \(String(describing: option))")
        //start with deepLink
    if case .character(let id) = option {
      guard let id = id else { fatalError()}
      presentCharacterDetailViewController(with: id)
    }
  }

  private func presentCharactersListViewController() {
    let viewModel = CharactersListViewModel(dependencies: dependencies)
    viewModel.coordinatorDelegate = self

    let viewController = CharactersListViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentCharacterDetailViewController(with characterId: String ) {
    let viewModel = CharacterDetailViewModel(dependencies: dependencies, characterId: characterId)
//    viewModel.coordinatorDelegate = self

    let viewController = CharacterDetailViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}

// MARK: - VC transitions handling
extension CharactersListCoordinator: CharactersListCoordinatorDelegate {
  func didGoBack() {
    guard let navigationController = presenter as? UINavigationController else { return }
    navigationController.popViewController(animated: true)
    parentCoordinator?.disposeChild(coordinator: self)
  }

  func didSelect(character: CharacterResult) {
    // Destination doesn't need coordination, just present the VC
    presentCharacterDetailViewController(with: character)
  }

  private func presentCharacterDetailViewController(with character: CharacterResult ) {
    let viewModel = CharacterDetailViewModel(dependencies: dependencies, character: character)
//    viewModel.coordinatorDelegate = self

    let viewController = CharacterDetailViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}
