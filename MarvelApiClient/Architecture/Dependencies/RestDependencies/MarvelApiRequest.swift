//
//  MarvelApiRequest.swift
//  MarvelApiClient
//
//  Created by franco bellu on 27/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

protocol MarvelApiRequest: RestAPIRequest{

  // number of items to be fetched each time (i.e., database LIMIT)
  //  var limit: Int  {get set}
  //
  //  // Where to start fetching items (database OFFSET). This is to support packets fetch
  //  var offset: Int {get set}
  //
  //  // a flag for when all database items have already been loaded
  //  var reachedEndOfItems: Bool {get set}
}

extension MarvelApiRequest{
  // Strips any wrapper around the requested object
  func extractApiObjectFrom(_ data: Data) -> Result<Self.Response, Error> {
    let dataContaineResult = self.decodeToMarvelResponseWrapper(data)
    return stripDataContainerFrom(dataContaineResult)
  }
}

private extension MarvelApiRequest{

  // Strips the MarvelApiResponse wrapper and returns a DataContainer object if exists
  private func decodeToMarvelResponseWrapper (_ data: Data) -> Result<DataContainer<Response>, Error> {
    var result: Result<DataContainer<Response>, Error>
    do {
      let marvelResponse = try JSONDecoder().decode(MarvelResponse<Response>.self, from: data)
      if let dataContainer = marvelResponse.data {
        result = .success(dataContainer)
      } else {
        result = .failure(MarvelError.noData)
      }
    } catch {
      // decode the ErrorResponse 
      _ = try? JSONDecoder().decode(ErrorResponse.self, from: data)
      result = .failure(MarvelError.decoding)
    }
    return result
  }

  //  Strips the DataContainer wrapper and returns a Response object if exists
  private func stripDataContainerFrom(_ dataContaineResult: Result<DataContainer<Self.Response>, Error>) -> Result<Response, Error> {
    let returnValue: Result<Response, Error>
    switch dataContaineResult{
    case .success(let dataContainer):
      let resultObject = dataContainer.results
      returnValue = .success(resultObject)
    case .failure(let error):
      returnValue = .failure(error)
    }
    return returnValue
  }
}
