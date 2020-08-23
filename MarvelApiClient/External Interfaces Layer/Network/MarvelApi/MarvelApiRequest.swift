//
//  MarvelApiRequest.swift
//  MarvelApiClient
//
//  Created by franco bellu on 27/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

public class MarvelApiRequest<T: Decodable>: ResponseRequestable {

  public typealias Response = T

  public var resourceName: String

  public var method: RestMethod

  public var bodyEncoding: BodyEncoding?

  public var urlParameters: [String: String]?

  public var encodableUrlParameters: Encodable?

  public var headerParamaters: [String: String]?

  public var bodyParameters: [String: String]?

  public var encodableBodyParamaters: Encodable?

  init(resourceName: String, method: RestMethod, urlParameters: [String: String]?) {

    self.resourceName = resourceName
    self.method = method
    self.urlParameters = urlParameters
  }
}

extension MarvelApiRequest {

  static func makeCharactersListRequest(from query: CharactersQuery) -> MarvelApiRequest {
    MarvelApiRequest(resourceName: "characters", method: .get, urlParameters: try? query.toDictionaryOfString())
  }

  static func makeCharacterRequest(from query: CharacterQuery) -> MarvelApiRequest {
    MarvelApiRequest(resourceName: "characters", method: .get, urlParameters: try? query.toDictionaryOfString())
  }
}

// 
extension MarvelApiRequest {
  // Strips any wrapper around the requested object
  public func extractApiObjectFrom(_ data: Data) -> Result<Response, RestApiRequestError> {
    let dataContaineResult = self.decodeToMarvelResponseWrapper(data)
    let marvelResult = stripDataContainerFrom(dataContaineResult)
    var returnValue: Result<Response, RestApiRequestError>?

    switch marvelResult {
    case .success(let responseValue):
      returnValue = .success(responseValue)
    case .failure:
      returnValue = .failure(.api)
    }
    return returnValue!
  }
}

private extension MarvelApiRequest {

  // Strips the MarvelApiResponse wrapper and returns a DataContainer object if exists
  private func decodeToMarvelResponseWrapper (_ data: Data) -> Result<DataContainer<Response>, MarvelApiError> {
    var result: Result<DataContainer<Response>, MarvelApiError>
    do {
      let marvelResponse = try JSONDecoder().decode(MarvelResponse<Response>.self, from: data)
      if let dataContainer = marvelResponse.data {
        result = .success(dataContainer)
      } else {
        result = .failure(MarvelApiError.noMarvelData)
      }
    } catch {
      // decode the ErrorResponse
      _ = try? JSONDecoder().decode(ErrorResponse.self, from: data)
      result = .failure(MarvelApiError.decoding)
    }
    return result
  }

  //  Strips the DataContainer wrapper and returns a Response object if exists
  private func stripDataContainerFrom(_ dataContaineResult: Result<DataContainer<Response>, MarvelApiError>) -> Result<Response, MarvelApiError> {
    let returnValue: Result<Response, MarvelApiError>
    switch dataContaineResult {
    case .success(let dataContainer):
      let resultObject = dataContainer.results
      returnValue = .success(resultObject)
    case .failure(let error):
      returnValue = .failure(error)
    }
    return returnValue
  }
}
