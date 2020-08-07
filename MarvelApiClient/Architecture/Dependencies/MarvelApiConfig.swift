//
//  MarvelApiConfig.swift
//  MarvelApiClient
//
//  Created by franco bellu on 22/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

struct MarvelApiRequestConfig: RestServiceConfigProtocol {

  var publicKey: String = "e7416283f4f02fb5ca8b883e421fa857"
  var privateKey: String = "b687a3d1c855db14f30638c2530e8ceb1dc93b0f"

  let baseEndpointString = "https://gateway.marvel.com:443/v1/public/"
  var baseEndpointUrl: URL? {
    guard let url = URL(string: baseEndpointString) else {return nil}
    return url
  }

  // Encodes a URL based on the given request using
  // Create a URLComponents url composing:
  // 1) baseUrl = baseEndpointUrl +  request.resourceName
  // 2) commonQueryItems ( marvel-specific params)
  // 3) customQueryItems ( request-specific params)
  func buildEndpointUrlFor(resourceName: String, parameters: [String: String]? = nil) -> URL? {
    // Build baseUrl = baseEndpointUrl +  request.resourceName
    guard let baseUrl = URL(string: resourceName, relativeTo: URL(string: baseEndpointString) ) else {
      return URL(string: baseEndpointString)
    }
    guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }

    guard let params =  try? apiParams() else{ return nil }
    print(params)
    // Build common query items needed for all Marvel requests
    guard let commonQueryItems = try? buildCommonQueryItemsFrom(apiParams: params) else{ return nil }
    print(commonQueryItems)

    // Build customQueryItems ( request-specific params)
    let customQueryItems = buildCustomQueryItems(parameters)

    components.queryItems = commonQueryItems + customQueryItems

    return components.url
  }

  private func apiParams() throws -> [String: String]{
    let timestamp = "\(Date().timeIntervalSince1970)"
    let str = "\(timestamp)\(privateKey)\(publicKey)"
    guard let digest =  str.insecureMD5Hash() else { throw MarvelError.encoding }

    let result = [ "ts": timestamp,
                   "hash": digest,
                   "apikey": publicKey ]

    return result
  }

  // Build commonQueryItems ( marvel-specific params)
  private func buildCommonQueryItemsFrom(apiParams: [String : String]) throws-> [URLQueryItem]{

    return apiParams.map{ ( key, value)  in
      URLQueryItem(name: key, value: value)
    }
  }

  // Build customQueryItems ( request-specific params)
  private func buildCustomQueryItems(_ parameters: [String: String]?) -> [URLQueryItem]{
    var result = [URLQueryItem]()
    if let params = parameters, !params.isEmpty {
      result = params.map { item, value in
        URLQueryItem(name: item, value: value)
      }
    }
    return result
  }
}
