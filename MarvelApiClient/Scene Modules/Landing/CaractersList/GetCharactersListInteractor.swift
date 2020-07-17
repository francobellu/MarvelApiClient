//
//  GetCharactersListInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//  PRESENTER INPUT
protocol GetCharactersListInteractorInputPort: class{
  func execute()
}

//  PRESENTER OUTPUT
protocol GetCharactersListInteractorOutputPort: class{
  func domainData(result: Result<DataContainer<GetCharacters.Response>, Error>)
}

private protocol GetCharactersListInteractorProtocol: class{
  init(dependencies: AppDependenciesProtocol)
  func handle(result: Result<DataContainer<GetCharacters.Response>, Error>)
}

class GetCharactersListInteractor{
  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  weak var output: GetCharactersListInteractorOutputPort?

  required init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }
}

extension GetCharactersListInteractor: GetCharactersListInteractorInputPort{

  // MARK: - Business logic
  func execute() {
    getCharactersList()
  }
}

// MARK: - PRIVATE functions
extension GetCharactersListInteractor{
  private func getCharactersList() {
    apiClient.getCharactersList { result in
      self.handle(result: result)
    }
  }

  fileprivate func handle(result: Result<DataContainer<GetCharacters.Response>, Error>){
    switch result {
    case .success:
      // completion is the interactor output port
      self.output?.domainData(result: result)
    case .failure(let error):
      print(error)
      self.output?.domainData(result: result)
    }
  }
}
