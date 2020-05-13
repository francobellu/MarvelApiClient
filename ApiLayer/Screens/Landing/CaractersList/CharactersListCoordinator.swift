//
//  CharactersListCoordinator.swift
//  ApiLayer
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

protocol CharactersListViewcoordinatorDelegate: class {
  func goBack()
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

  deinit {
    print("FB:CharactersListCoordinator:deinit()")
  }
}

extension CharactersListCoordinator: Coordinator, DeepLinkable {

  func start() {
    print("FB:CharactersListCoordinator:start()")
    presentCharactersListViewController()
  }

  func start(with option: DeepLinkOption?) {
       print("FB:CharactersListCoordinator:start(with: \(option)")
        //start with deepLink
    if case .character(let id) = option {
      guard let id = id else { fatalError()}
      presentCharacterDetailViewController(with: id)
    }
  }

  private func presentCharactersListViewController() {
    let viewController = CharactersListViewController.instantiateViewController()
    viewController.coordinatorDelegate = self
    print("FB:  Created VC: \(viewController) ")

    // Inject the ViewModel
    let viewModel = CharactersListViewModel(dependencies: dependencies)
    viewController.viewModel = viewModel
    print("FB:  Presenting VC: \(viewController) ")

    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentCharacterDetailViewController(with characterId: String ) {
    let viewModel = CharacterDetailViewModel(dependencies: dependencies, characterId: characterId)
    let viewController = CharacterDetailViewController.instantiateViewController()
    viewController.viewModel = viewModel
    //viewController.coordinatorDelegate = self
    print("FB:  Created VC: \(viewController) ")
    print("FB:  Presenting VC: \(viewController) ")
    (presenter as? UINavigationController)?.pushViewController(viewController, animated: true)
  }

  private func presentCharacterDetailViewController(with character: CharacterResult ) {
    let viewModel = CharacterDetailViewModel(dependencies: dependencies, character: character)
    let viewController = CharacterDetailViewController.instantiateViewController()
    viewController.viewModel = viewModel
    //viewController.coordinatorDelegate = self
    print("FB:  Created VC: \(viewController) ")
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

  func didSelect(character: CharacterResult) {
    // Destination doesn't need coordination, just present the VC
    presentCharacterDetailViewController(with: character)
//    let characterDetailVc = CharacterDetailViewController.instantiateViewController()
//    characterDetailVc.character = character
//    (presenter as? UINavigationController)?.pushViewController(characterDetailVc, animated: true)
  }
}
