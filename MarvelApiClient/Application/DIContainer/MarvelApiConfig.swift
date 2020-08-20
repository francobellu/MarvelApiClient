//
//  MarvelApiConfig.swift
//  MarvelApiClient
//
//  Created by franco bellu on 22/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

struct MarvelApiRequestConfig {
  var publicKey: String = "e7416283f4f02fb5ca8b883e421fa857"
  var privateKey: String = "b687a3d1c855db14f30638c2530e8ceb1dc93b0f"

  let baseEndpointString = "https://gateway.marvel.com:443/v1/public/"
  var baseEndpointUrl: URL? {
    guard let url = URL(string: baseEndpointString) else {return nil}
    return url
  }
   func apiUrlParams() throws -> [String: String]{
    let timestamp = "\(Date().timeIntervalSince1970)"
    let str = "\(timestamp)\(privateKey)\(publicKey)"
    guard let digest = str.insecureMD5Hash() else { throw MarvelError.insecureMD5Hash }

    let result = [ "ts": timestamp,
                   "hash": digest,
                   "apikey": publicKey ]

    return result
  }
}
