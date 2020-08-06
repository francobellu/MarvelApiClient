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
protocol RestDependenciesProtocol{
  // This is the dependency on the external Rest framework
  var restApiClient: RestApiClient { get set}

  var apiRequestConfig: RestServiceConfigProtocol { get}

//  var method: RestMethod { get set}
}

public enum RestMethod {
  case get, post, put, patch, delete
}

class RestDependencies: RestDependenciesProtocol{

  var restApiClient = RestApiClient()

//  var marvelApiClient: MarvelApiProtocol {
//    MarvelApiClient(restApiClient: res)
//  }

  var apiRequestConfig: RestServiceConfigProtocol = MarvelApiRequestConfig()

//  var method: RestMethod = .get

  init() {
  }
}
