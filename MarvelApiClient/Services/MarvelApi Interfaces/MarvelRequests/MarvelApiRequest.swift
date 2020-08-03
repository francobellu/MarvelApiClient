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

  var restDependencies: RestDependenciesProtocol { get set }

//  func execute(completion: @escaping (Result<Response, Error>) -> Void)
}

extension MarvelApiRequest{
  /// Send the request with a completion handler
//  func execute(completion: @escaping (Result<Response, Error>) -> Void) {
//    restDependencies.restApiClient.send(self) { (result: Result<(URLResponse, Data), Error>) in
//      let responseResult = self.handleResult(result)
//      completion(responseResult)
//    }
//  }

  ///  Decodes the  response data  stripping all the wrappers.  In the process  all the possible errors are handled
  /// - Parameters:
  ///   - data: The data as returned by the Service
  /// - Returns: A Result encasulating the response object for the request or an Error
  func decode(_ data: Data) -> Result<Response, Error> {
    let dataContaineResult = self.decodeToMarvelResponseWrapper(data)
    return stripDataContainerFrom(dataContaineResult)
  }
}

private extension MarvelApiRequest{
  private func handleResult(_ result: Result<(URLResponse, Data), Error>) ->  Result<Response, Error> {
    var completionValue: Result<Response, Error>
    switch result {
    case .success((_, let data)):
      completionValue = self.decode(data)
    case .failure(let error):
      completionValue = .failure(error)
    }
    return completionValue
  }

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
