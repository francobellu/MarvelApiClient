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
  func didSelect(character: Character)
}

class CharactersListCoordinator: NSObject {

  var coordinatorPresenter: AnyObject?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  private var dependencies: AppDIContainerProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  init(parentCoordinator: Coordinator, coordinatorPresenter: UINavigationController, dependencies: AppDIContainerProtocol) {
    print("FB:CharactersListCoordinator:init()")
    self.dependencies = dependencies
    self.parentCoordinator = parentCoordinator
    self.coordinatorPresenter = coordinatorPresenter
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
    switch option {
    case .character(let id):
      guard let id = id else { fatalError()}
      presentCharacterDetailViewController(with: id)
    case .characters:
      presentCharactersListViewController()
    default:
      return
    }
  }
}

// MARK: - CharactersListCoordinatorDelegate VC transitions handling
extension CharactersListCoordinator: CharactersListCoordinatorDelegate {
  func didGoBack() {
    popView()
  }

  func didSelect(character: Character) {
    // Destination doesn't need coordination, just present the VC
    presentCharacterDetailViewController(with: character)
  }
}

// MARK: - Implementation details
private extension CharactersListCoordinator {
  private func presentCharactersListViewController() {
    let view = dependencies.factory.makeCharactersView(coordinatorDelegate: self)
     (coordinatorPresenter as? UINavigationController)?.pushViewController(view, animated: true)
   }

   private func presentCharacterDetailViewController(with characterId: String ) {
    let view = dependencies.factory.makeCharacterDetailView(with: characterId)
     (self.coordinatorPresenter as? UINavigationController)?.pushViewController(view, animated: true)
   }

  private func presentCharacterDetailViewController(with character: Character ) {
    let viewController = dependencies.factory.makeCharacterDetailView(character: character)
    (coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func popView() {
    guard let navigationController = coordinatorPresenter as? UINavigationController else { return }
    if navigationController.viewControllers.count > 1 {
      navigationController.popViewController(animated: true)
      parentCoordinator?.disposeChild(coordinator: self)
    }
  }
}
