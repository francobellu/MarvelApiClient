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
  func makeCharacterDetailPresenter(with character: CharacterResult) -> CharacterDetailPresenter
}

protocol PresenterFactory {
  // Characters
  func makeCharactersListPresenter(with characterId: String, coordinatorDelegate: CharactersListCoordinatorDelegate  ) -> CharactersListPresenter

  // CharacterDetail
  func makeCharacterDetailView(character: CharacterResult) -> CharacterDetailViewController
  func makeCharacterDetailView(with characterId: String ) -> CharacterDetailViewController
}


// Factory pattern
class Factory {

  let dependencies: AppDependenciesProtocol
  // Factory functions

  init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }
}

extension Factory: ViewControllerFactory{
  func makeCharactersView(coordinatorDelegate: CharactersListCoordinatorDelegate) -> CharactersListViewController{
    let interactor = GetCharactersListInteractor(dependencies: dependencies)

    let presenter = CharactersListPresenter(dependencies: dependencies, coordinatorDelegate: coordinatorDelegate, interactor: interactor)

    interactor.outputPort = presenter

    let view  = CharactersListViewController.instantiateViewController()

    view.presenter = presenter

    return view
  }
  func makeCharacterDetailView(character: CharacterResult) -> CharacterDetailViewController{
    let viewPresenter = CharacterDetailPresenter(dependencies: dependencies, character: character)
    let view  = CharacterDetailViewController.instantiateViewController()
    view.presenter = viewPresenter
    return view
  }

  func makeCharacterDetailView(with characterId: String ) -> CharacterDetailViewController{
    let interactor = CharacterDetailInteractor(dependencies: dependencies)

    let presenter = CharacterDetailPresenter(dependencies: dependencies, characterId: Int(characterId)!, interactor: interactor)

    let view = CharacterDetailViewController.instantiateViewController()

    view.presenter = presenter

    return view
  }

}

extension Factory: PresenterFactory{
  func makeCharactersListPresenter(with characterId: String, coordinatorDelegate: CharactersListCoordinatorDelegate  ) -> CharactersListPresenter{

     let interactor = GetCharactersListInteractor(dependencies: dependencies)

     return  CharactersListPresenter(dependencies: dependencies, coordinatorDelegate: coordinatorDelegate, interactor: interactor)
   }

  func makeCharacterDetailPresenter(with characterId: String) -> CharacterDetailPresenter{

    let interactor = CharacterDetailInteractor(dependencies: dependencies)

    return CharacterDetailPresenter(dependencies: dependencies, characterId: Int(characterId)!, interactor: interactor)
  }

  func makeCharacterDetailPresenter(with character: CharacterResult) -> CharacterDetailPresenter{

    let interactor = CharacterDetailInteractor(dependencies: dependencies)

    return CharacterDetailPresenter(dependencies: dependencies, character: character)
  }
}
