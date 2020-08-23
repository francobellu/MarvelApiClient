//
//  Factory.swift
//  MarvelApiClient
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

protocol ViewControllerFactory {

  // Characters
  func makeCharactersView(coordinatorDelegate: CharactersListCoordinatorDelegate) -> CharactersListViewController

  // CharacterDetail
  func makeCharacterDetailPresenter(with characterId: String) -> CharacterDetailPresenter
  func makeCharacterDetailPresenter(with character: Character) -> CharacterDetailPresenter
}

protocol PresenterFactory {
  // Characters
  func makeCharactersListPresenter(with characterId: String, coordinatorDelegate: CharactersListCoordinatorDelegate  ) -> CharactersListPresenter

  // CharacterDetail
  func makeCharacterDetailView(character: Character) -> CharacterDetailViewController
  func makeCharacterDetailView(with characterId: String ) -> CharacterDetailViewController
}

protocol CharactersRepositoryFactory {
  // Characters
   func makeCharactersRepository() -> CharactersRepository
}

// Factory pattern
class Factory {

  let dependencies: AppDIContainerProtocol
  // Factory functions

  init(dependencies: AppDIContainerProtocol) {
    self.dependencies = dependencies
  }
}

extension Factory: ViewControllerFactory {
  func makeCharactersView(coordinatorDelegate: CharactersListCoordinatorDelegate) -> CharactersListViewController {
    let repo = dependencies.factory.makeCharactersRepository()
    let interactor = GetCharactersListInteractor(charactersRepository: repo)

    let presenter = CharactersListPresenter(dependencies: dependencies, coordinatorDelegate: coordinatorDelegate, interactor: interactor)

    interactor.outputPort = presenter

    let view  = CharactersListViewController.instantiateViewController()

    view.presenter = presenter

    return view
  }

  // make from a specific character already present ( when selected from list view)
  func makeCharacterDetailView(character: Character) -> CharacterDetailViewController {
    let viewPresenter = CharacterDetailPresenter(dependencies: dependencies, character: character)
    let view  = CharacterDetailViewController.instantiateViewController()
    view.presenter = viewPresenter
    return view
  }

  func makeCharacterDetailView(with characterId: String ) -> CharacterDetailViewController {
    let interactor = GetCharacterInteractor(dependencies: dependencies)

    let presenter = CharacterDetailPresenter(dependencies: dependencies, id: Int(characterId)!, interactor: interactor)

    let view = CharacterDetailViewController.instantiateViewController()

    view.presenter = presenter

    return view
  }

}

extension Factory: PresenterFactory {
  func makeCharactersListPresenter(with characterId: String, coordinatorDelegate: CharactersListCoordinatorDelegate  ) -> CharactersListPresenter {
    let repo = dependencies.factory.makeCharactersRepository()
    let interactor = GetCharactersListInteractor(charactersRepository: repo)

     return  CharactersListPresenter(dependencies: dependencies, coordinatorDelegate: coordinatorDelegate, interactor: interactor)
   }

  func makeCharacterDetailPresenter(with characterId: String) -> CharacterDetailPresenter {

    let interactor = GetCharacterInteractor(dependencies: dependencies)

    return CharacterDetailPresenter(dependencies: dependencies, id: Int(characterId)!, interactor: interactor)
  }

  func makeCharacterDetailPresenter(with character: Character) -> CharacterDetailPresenter {

    // No interactor in this case
//    let interactor = GetCharacterInteractor(dependencies: dependencies)

    return CharacterDetailPresenter(dependencies: dependencies, character: character)
  }
}

extension Factory: CharactersRepositoryFactory {
  func makeCharactersRepository() -> CharactersRepository {

    return DefaultCharactersRepository(marvelApiClient: dependencies.marvelApiClient)
  }
}

protocol MarvelApiClientFactory {
  func makeMarvelApiClient() -> MarvelApiProtocol
}

extension Factory: MarvelApiClientFactory {
  func makeMarvelApiClient() -> MarvelApiProtocol {
    return MarvelApiClient(restDependencies: dependencies.restDependencies)
  }
}
