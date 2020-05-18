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

  var presenter: AnyObject?
  weak var parentCoordinator: Coordinator?
  var coordinators = [Coordinator]()
  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

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
    if case .characters = option {
      presentCharactersListViewController()
    }
  }

  private func presentCharactersListViewController() {
    let viewModel = CharactersListViewModel(dependencies: dependencies, coordinatorDelegate: self)

    let viewController = CharactersListViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentCharacterDetailViewController(with characterId: String ) {
    let viewModel = CharacterDetailViewModel(dependencies: self.dependencies, characterId: characterId)
    DispatchQueue.global(qos: .background).async{
      guard let id = Int(characterId)  else {
        print("Invalid deepLink url")
        return
      }
      viewModel.getCharacter(with: id){
        DispatchQueue.main.sync{
          let viewController = CharacterDetailViewController.instantiateViewController()
          viewController.viewModel = viewModel
          (self.presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
        }
      }
    }
  }
}

// MARK: - VC transitions handling
extension CharactersListCoordinator: CharactersListCoordinatorDelegate {
  func didGoBack() {
    guard let navigationController = presenter as? UINavigationController else { return }
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
    let viewModel = CharacterDetailViewModel(dependencies: dependencies, character: character)

    let viewController = CharacterDetailViewController.instantiateViewController()
    viewController.viewModel = viewModel

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }
}
