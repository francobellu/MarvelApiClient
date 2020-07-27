//
//  MarvelApiConfig.swift
//  MarvelApiClient
//
//  Created by franco bellu on 22/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

struct MarvelApiRequestConfig: ServiceConfigProtocol {

  var publicKey: String? = "e7416283f4f02fb5ca8b883e421fa857"
  var privateKey: String? = "b687a3d1c855db14f30638c2530e8ceb1dc93b0f"

  let baseEndpointString = "https://gateway.marvel.com:443/v1/public/"
  var baseEndpointUrl: URL? {
    guard let url = URL(string: baseEndpointString) else {return nil}
    return url
  }

  // Encodes a URL based on the given request using
  // Create a URLComponents url composing:
  // 1) baseUrl = baseEndpointUrl +  request.resourceName
  // 2) commonQueryItems
  // 3) customQueryItems a partir de request object
  func buildEndpointUrl(for resourceName: String, and parameters: [String: String]? = nil) -> URL? { //swiftlint:disable:this function_body_length
      guard let baseUrl = URL(string: resourceName, relativeTo: URL(string: baseEndpointString) ) else {
  //      fatalError("Bad resourceName: \(resourceName)")
        return URL(string: baseEndpointString)
      }
      guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) else { return nil }

      // Common query items needed for all Marvel requests
      var commonQueryItems = [URLQueryItem]()

      if let privateKey = privateKey, let publicKey = publicKey{
        let timestamp = "\(Date().timeIntervalSince1970)"

        let str = "\(timestamp)\(privateKey)\(publicKey)"

        guard let digest =  str.insecureMD5Hash() else { return nil }
        commonQueryItems = [
          URLQueryItem(name: "ts", value: timestamp),
          URLQueryItem(name: "hash", value: digest),
          URLQueryItem(name: "apikey", value: publicKey)
        ]
      }

      // Custom query items needed for this specific request
      var customQueryItems = [URLQueryItem]()

      if let params = parameters, !params.isEmpty {
        customQueryItems = params.map { item, value in
          URLQueryItem(name: item, value: value)
        }
      }

      components.queryItems = commonQueryItems + customQueryItems

      // Construct the final URL with all the previous data
      return components.url
    }
}
