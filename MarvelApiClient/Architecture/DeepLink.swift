//
//  DeepLink.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

struct DeepLinkURLConstants {
  static let onboarding = "onboarding"
  static let landing = "landing"
  static let characters = "characters"
  static let character = "character"
  static let comics = "comic"
  static let comic = "comics"
}

enum DeepLinkOption {
  case onboarding
  case landing
//  case characters
  case character(String?)
  case characters
  case comic(String?)
  case comics

  static func build(with id: String, params: [String: AnyObject]?) -> DeepLinkOption? {
    let id = params?["id"] as? String
    switch id {
    case DeepLinkURLConstants.onboarding: return .onboarding
    case DeepLinkURLConstants.landing: return .landing
    case DeepLinkURLConstants.comic: return .comic(id)
    case DeepLinkURLConstants.character: return .character(id)
    default: return nil
    }
  }
}


class DeeplinkParser {
   static let shared = DeeplinkParser()
   private init() { }

  // swiftlint:disable:next function_body_length
  func parseDeepLink(_ url: URL) -> DeepLinkOption? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
      let host = components.host else {
        return nil
    }
    var pathComponents = components.path.components(separatedBy: "/")
    // the first component is empty
    pathComponents.removeFirst()
    switch host {
    case "onboarding": return DeepLinkOption.onboarding
    case "landing": return DeepLinkOption.landing
    case "character":
      if let id = pathComponents.first {
        return DeepLinkOption.character(id)
      }
    case "characters": return DeepLinkOption.characters
    case "comics": return DeepLinkOption.comics
    case "comic":
      if let id = pathComponents.first {
        return DeepLinkOption.comic(id)
      }
    default:
      break
    }
    return nil
  }

  @discardableResult
  func handleDeeplink(url: URL) -> Bool {
     let deepLinkOption = DeeplinkParser.shared.parseDeepLink(url)
     return deepLinkOption != nil
  }
}
