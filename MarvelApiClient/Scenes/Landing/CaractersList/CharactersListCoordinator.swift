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

class CharactersListCoordinator: NSObject {

  var coordinatorPresenter: AnyObject?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  init(parentCoordinator: Coordinator, coordinatorPresenter: UINavigationController, dependencies: AppDependenciesProtocol) {
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

  private func presentCharactersListViewController() {

    let interactor = CharactersListInteractor(dependencies: dependencies)

    let presenter = CharactersListPresenter(dependencies: dependencies, coordinatorDelegate: self, interactor: interactor)

    let viewController = CharactersListViewController.instantiateViewController()
    viewController.presenter = presenter

    presenter.viewControllerDelegate = viewController

    (coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentCharacterDetailViewController(with characterId: String ) {
    let interactor = CharacterDetailInteractor(dependencies: dependencies)

    let presenter = CharacterDetailPresenter(dependencies: self.dependencies, characterId: characterId, interactor: interactor)

    DispatchQueue.global(qos: .background).async{
      guard let id = Int(characterId)  else {
        print("Invalid deepLink url")
        return
      }
      presenter.getCharacter(with: id){ // TODO fare con il binding
        DispatchQueue.main.sync{
          let viewController = CharacterDetailViewController.instantiateViewController()
          viewController.presenter = presenter
          (self.coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
        }
      }
    }
  }
}

// MARK: - VC transitions handling
extension CharactersListCoordinator: CharactersListCoordinatorDelegate {
  func didGoBack() {
    guard let navigationController = coordinatorPresenter as? UINavigationController else { return }
    if navigationController.viewControllers.count > 1{
      navigationController.popViewController(animated: true)
      parentCoordinator?.disposeChild(coordinator: self)
    }
  }

  func didSelect(character: CharacterResult) {
    // Destination doesn't need coordination, just present the VC
    presentCharacterDetailViewController(with: character)
  }

  private func presentCharacterDetailViewController(with character: CharacterResult ) {
    let viewPresenter = CharacterDetailPresenter(dependencies: dependencies, character: character)

    let viewController = CharacterDetailViewController.instantiateViewController()
    viewController.presenter = viewPresenter

    (coordinatorPresenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}
