//
//  RestDependencies.swift
//  MarvelApiClient
//
//  Created by franco bellu on 30/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

public enum RestMethod: String {
  case get, post, put, patch, delete
}

// External dependency abstraction
protocol RestDependenciesProtocol{
  // This is the dependency on the external Rest framework
  var httpService: DefaultHttpService { get}

  var apiConfig: NetworkConfigurable {get}
}

class RestDependencies: RestDependenciesProtocol{
  let httpService: DefaultHttpService

  let apiConfig: NetworkConfigurable

//  var apiRequestConfig: RestServiceConfigProtocol = MarvelApiRequestConfig()

  init(marvelApiConfig: MarvelApiRequestConfig = MarvelApiRequestConfig())  {

    let marvelApiConfig = MarvelApiRequestConfig()
    do {
      let params =  try marvelApiConfig.apiUrlParams()
      apiConfig = ApiNetworkConfiguration(baseURL: marvelApiConfig.baseEndpointUrl!,
                                          headerParamaters: nil,
                                          urlParameters: params)

      self.httpService = DefaultHttpService()
    } catch  {
      print("Error creating MD5 hash\(error)")
      fatalError()
    }
  }
}
