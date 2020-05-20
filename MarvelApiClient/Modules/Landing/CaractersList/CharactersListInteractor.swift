//
//  CharactersListInteractor.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharactersListInteractor {

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelAPIProtocol{
    dependencies.marvelApiClient
  }

  private var characters: [CharacterResult] = []

  init(dependencies: AppDependenciesProtocol) {
    self.dependencies = dependencies
  }

  // MARK: - Business logic
  func getNextCharactersList(completion: @escaping ([CharacterResult]) -> Void) {
    apiClient.getCharactersList { response in

      switch response {
      case .success(let dataContainer):

        // 3) append the new results into the data source for the tems table view
        //weakself.characters += dataContainer.results
        //guard let results = dataContainer.results else { return}
        completion(dataContainer.results)
        for character in dataContainer.results {
          guard let thumbnail = character.thumbnail else {return}
          print("FB:  Title: \(character.name ?? "Unnamed character")")
          print("  Thumbnail: \(thumbnail.url.absoluteString)")
        }
      case .failure(let error):
        print(error)
      }
      completion(self.characters)
    }
  }
}
