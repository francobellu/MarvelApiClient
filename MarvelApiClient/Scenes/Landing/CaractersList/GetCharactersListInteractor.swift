//
//  GetCharactersListInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation


protocol GetCharactersListInteractorInputPort{
  var presenterDelegate: GetCharactersListInteractorOutputPort? { get set }
  func execute()
}

// Implemented in the Presentation Layer
protocol GetCharactersListInteractorOutputPort: class{

  var interactorCompletion: (([CharacterResult]) -> Void)? {get set}
}

class GetCharactersListInteractor: GetCharactersListInteractorInputPort{

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  weak var presenterDelegate: GetCharactersListInteractorOutputPort?

  required init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }

  // MARK: - Business logic
  func execute() {
    apiClient.getCharactersList { response in

      switch response {
      case .success(let dataContainer):
        // completion is the interactor output port
        self.presenterDelegate?.interactorCompletion?(dataContainer.results)
      case .failure(let error):
        print(error)
        self.presenterDelegate?.interactorCompletion?([CharacterResult]())
      }
    }
  }
}
