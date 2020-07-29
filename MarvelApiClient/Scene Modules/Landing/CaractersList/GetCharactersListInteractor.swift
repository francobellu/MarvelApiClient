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
  func domainData(result: Result<GetCharacters.Response, Error>)
}

private protocol GetCharactersListInteractorProtocol: class{
  init(dependencies: AppDependenciesProtocol)
  func handle(result: Result<[GetCharacters.Response], Error>)
}

class GetCharactersListInteractor{
  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

//  private var apiClient: MarvelApiProtocol{
//    dependencies.marvelApiClient
//  }

  weak var outputPort: GetCharactersListInteractorOutputPort?

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
private extension GetCharactersListInteractor{
  private func getCharactersList() {
    let request = GetCharacters(restDependencies: dependencies.restDependencies, limit: 20, offset: 0)
    request.execute { result in
      self.handle(results: result)
    }
  }

  private func handle(results: Result<GetCharacters.Response, Error>){
    switch results {
    case .success:
      // completion is the interactor output port
      self.outputPort?.domainData(result: results)
    case .failure(let error):
      print(error)
      self.outputPort?.domainData(result: results)
    }
  }
}
