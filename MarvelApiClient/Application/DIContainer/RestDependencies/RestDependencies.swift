//
//  RestDependencies.swift
//  MarvelApiClient
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

// External dependency abstraction
protocol RestDependenciesProtocol {
  // This is the dependency on the external Rest framework
  var restService: RestService { get}
}

class RestDependencies: RestDependenciesProtocol {

  let restService: RestService

  init(marvelApiConfig: MarvelApiRequestConfig) {
    let apiConfig: NetworkConfigurable = {
      do {
        let params =  try marvelApiConfig.apiUrlParams()
        let apiConfig = ApiNetworkConfiguration(baseURL: marvelApiConfig.baseEndpointUrl!,
                                                headerParamaters: nil,
                                                urlParameters: params)
        return apiConfig
      } catch {
        print("Error creating MD5 hash\(error)")
        fatalError()
      }
    }()

    restService = DefaultRestService(apiNetworkConfig: apiConfig)
  }
}
