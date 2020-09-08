//
//  Extensions.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.

import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
  static var storyboardIdentifier: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
  // THE VC IDENTIFIER MUST BE EQUAL TO THE CLASS FILENAME BECAUSE WE USE THIS NAME TO TO INSTANTIATE THE OBJECT
  static var storyboardIdentifier: String {
    // Return the filename, which is the name of a class without the module name.
    guard let string = NSStringFromClass(Self.self).components(separatedBy: ".").last else { return "" }
    return string
  }

  static func instantiateViewController(name: String = "Main", _ bundle: Bundle? = nil) -> Self {
    let storyB = UIStoryboard(name: name, bundle: bundle)
    guard let viewC = storyB.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else { fatalError()}
    return viewC
  }
}

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

    let queryError = NSError(domain: "com.marvelApiClient.Utils", code: 1, userInfo: nil)
    guard let dict = josnData as? [String: Any]  else {throw queryError} // returns nil
    let newDict: [String: String]  = dict.mapValues{ value in
      "\(value)"
    }
    return newDict
  }
}

enum UtilsError: Error{

}
