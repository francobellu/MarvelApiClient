//
//  DeepLink.swift
//  ApiLayer
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

struct DeepLinkURLConstants {
  static let onboarding = "onboarding"
  static let characters = "characters"
  static let character = "character"
  static let landing = "landing"
}

enum DeepLinkOption {
  case onboarding
  case landing
//  case characters
  case character(String?)

  static func build(with id: String, params: [String: AnyObject]?) -> DeepLinkOption? {
    let character = params?["character"] as? String
    switch id {
    case DeepLinkURLConstants.onboarding: return .onboarding
    case DeepLinkURLConstants.landing: return .landing
//      case DeepLinkURLConstants.characters: return .characters
    case DeepLinkURLConstants.character: return .character(character)
    default: return nil
    }
  }
}

class DeeplinkParser {
   static let shared = DeeplinkParser()
   private init() { }

  func parseDeepLink(_ url: URL) -> DeepLinkOption? {
     guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
        return nil
     }
     var pathComponents = components.path.components(separatedBy: "/")
     // the first component is empty
    pathComponents.removeFirst()
    switch host {
    case "onboarding":
      return DeepLinkOption.onboarding
    case "landing":
      return DeepLinkOption.landing
    case "character":
      if let name = pathComponents.first {
        return DeepLinkOption.character(name)
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
