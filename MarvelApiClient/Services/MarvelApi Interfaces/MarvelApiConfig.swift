//
//  MarvelApiConfig.swift
//  MarvelApiClient
//
//  Created by franco bellu on 22/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation
import Rest

struct MarvelApiRequestConfig: ApiRequestConfigProtocol {
  let baseEndpointString = "https://gateway.marvel.com:443/v1/public/"
  var baseEndpointUrl: URL? {
    guard let url = URL(string: baseEndpointString) else {return nil}
    return url
  }

  let publicKey = "e7416283f4f02fb5ca8b883e421fa857"
  let privateKey = "b687a3d1c855db14f30638c2530e8ceb1dc93b0f"
}
