//
//  MarvelApiRequest.swift
//  MarvelApiClient
//
//  Created by franco bellu on 27/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

public class MarvelApiRequest<T: Decodable>: ResponseRequestable{

  public typealias Response = T

  public var resourceName: String

  public var method: RestMethod

  public var bodyEncoding: BodyEncoding?

  public var urlParameters: [String: String]?

  public var encodableUrlParameters: Encodable?

  public var headerParamaters: [String: String]?

  public var bodyParameters: [String: String]?

  public var encodableBodyParamaters: Encodable?

  //  var restDependencies: RestDependenciesProtocol

  static func makeCharactersListRequest(from query: CharactersQuery) -> MarvelApiRequest{
    MarvelApiRequest(resourceName: "characters", method: .get, urlParameters: try? query.toDictionaryOfString())
  }

  static func makeCharacterRequest(from query: CharacterQuery) -> MarvelApiRequest{
    MarvelApiRequest(resourceName: "characters", method: .get, urlParameters: try? query.toDictionaryOfString())
  }

  init(resourceName: String, method: RestMethod, urlParameters: [String: String]?) {

    //    self.restDependencies = restDependencies
    self.resourceName = resourceName
    self.method = method
    self.urlParameters = urlParameters
  }

  // number of items to be fetched each time (i.e., database LIMIT)
  //  var limit: Int  {get set}
  //
  //  // Where to start fetching items (database OFFSET). This is to support packets fetch
  //  var offset: Int {get set}
  //
  //  // a flag for when all database items have already been loaded
  //  var reachedEndOfItems: Bool {get set}
}
//
extension MarvelApiRequest {

  ///  Decodes the  response data  stripping all the wrappers.  In the process  all the possible errors are handled
  /// - Parameters:
  ///   - data: The data as returned by the Service
  /// - Returns: A Result encasulating the response object for the request or an Error
  public func decode(_ data: Data) -> Result<Response, Error>  {
    return extractApiObjectFrom(data)
  }

  // Strips any wrapper around the requested object
  public func extractApiObjectFrom(_ data: Data) -> Result<Response, Error> {
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
  private func stripDataContainerFrom(_ dataContaineResult: Result<DataContainer<Response>, Error>) -> Result<Response, Error> {
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
