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

import CryptoKit
private protocol ByteCountable {
  static var byteCount: Int { get }
}

extension Insecure.MD5: ByteCountable { }
extension Insecure.SHA1: ByteCountable { }

public extension String {

  func insecureMD5Hash(using encoding: String.Encoding = .utf8) -> String? {
    return self.hash(algo: Insecure.MD5.self, using: encoding)
  }

  func insecureSHA1Hash(using encoding: String.Encoding = .utf8) -> String? {
    return self.hash(algo: Insecure.SHA1.self, using: encoding)
  }

  private func hash<Hash: HashFunction & ByteCountable>(algo: Hash.Type, using encoding: String.Encoding = .utf8) -> String? {
    guard let data = self.data(using: encoding) else {
      return nil
    }

    return algo.hash(data: data).prefix(algo.byteCount).map {
      String(format: "%02hhx", $0)
    }.joined()
  }

}

