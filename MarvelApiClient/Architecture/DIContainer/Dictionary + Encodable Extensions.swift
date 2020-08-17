//
//  Extensions.swift
//  MarvelApiClient
//
//  Created by franco bellu on 12/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String: Any]
    }

  func toDictionaryOfString() throws -> [String: String]? {
      let data = try JSONEncoder().encode(self)
      let josnData = try JSONSerialization.jsonObject(with: data)
      return josnData as? [String: String]
  }
}
