//
//  MarvelApiClientUiError.swift
//  MarvelApiClient
//
//  Created by franco bellu on 22/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

public let appErrorDomain = "com.MarvelApiClient.App"

enum MarvelApiClientUiError: Error/*, Equatable */{
  //  public static func == (lhs: MarvelApiClientUiError, rhs: MarvelApiClientUiError) -> Bool {
  //    switch (lhs, rhs) {
  //    case (.networkFailure, .networkFailure): return false
  //    case (.restApiRequest, .restApiRequest): return true
  //    default: return false
  //    }
  //  }

  case noInternet
  case unhandled
  case marvelError_decoding
  case marvelError_noMarvelData
  case marvelError_insecureMD5Hash
  case networkError_responseCorrupted
  case networkError_dataTaskCancelled
  case networkError_notConnected
  case networkError_statusCode(_: Int, data: Data? = nil)
  case networkError_otherError(_ error: Error)
}

class MarvelApiClientUiErrorBuilder {
  private static let errorDomain = "com.marvelApiClient.ui"

  public static func newError(error: MarvelApiClientUiError, underlyingError: NSError? = nil) -> NSError {
    var userInfo = [String: Any]()
    userInfo[NSUnderlyingErrorKey] = underlyingError
    userInfo[NSLocalizedDescriptionKey] = localizedDescriptionForError(error: error)
    userInfo[NSLocalizedFailureReasonErrorKey] = failureReasonForError(error: error)

    let code = codeForError(error)
    return NSError(domain: MarvelApiClientUiErrorBuilder.errorDomain, code: code, userInfo: userInfo)
  }

  private static func codeForError(_ error: MarvelApiClientUiError) -> Int {
    let code: Int
    switch error {
    case .noInternet: code = 100
    case .unhandled: code = 101
    case .marvelError_decoding: code = 102
    case .marvelError_noMarvelData: code = 103
    case .marvelError_insecureMD5Hash: code = 104
    case .networkError_responseCorrupted: code = 107
    case .networkError_dataTaskCancelled: code = 108
    case .networkError_notConnected: code = 109
    case .networkError_statusCode: code = 110
    case .networkError_otherError: code = 111
    }
    return code
  }


  private static func localizedDescriptionForError(error: MarvelApiClientUiError) -> String { // swiftlint:disable:this function_body_length
    let returnString: String
    switch error {
    case .noInternet:
      returnString = NSLocalizedString("No Internet!!", comment: errorDomain)
    case .unhandled:
      #if DEBUG
      returnString = NSLocalizedString("Error domain: \( (error as NSError).domain)\nCode: \( (error as NSError).code)", comment: errorDomain)
      #endif
    case .marvelError_decoding:
      returnString = NSLocalizedString("The data was not properly decoded", comment: errorDomain)
    case .marvelError_noMarvelData:
      returnString = NSLocalizedString("No Data is present in the Marvel Api response", comment: errorDomain)
    case .marvelError_insecureMD5Hash:
      returnString = NSLocalizedString("insecureMD5Has", comment: errorDomain)
    case .networkError_responseCorrupted:
      returnString = NSLocalizedString("Response and Data don't match", comment: errorDomain)
    case .networkError_dataTaskCancelled:
      returnString = NSLocalizedString("Asynch operation cancelled", comment: errorDomain)
    case .networkError_notConnected:
      returnString = NSLocalizedString("No Internet!!", comment: errorDomain)
    case .networkError_statusCode:
      returnString = NSLocalizedString("Status code error ( from App Error)", comment: errorDomain)
    case .networkError_otherError:
      returnString = NSLocalizedString("Unclassified network error", comment: errorDomain)
    }
    #if DEBUG
      print("Error domain: \( (error as NSError).domain)\nCode: \( (error as NSError).code)")
    #endif
    return returnString
  }

  private static func failureReasonForError(error: MarvelApiClientUiError) -> String {
    switch error {
      //    case AppErrorCode.anErrorCase.rawValue:
    //      return NSLocalizedString("your localised error failure reason", comment: "ModuleName")
    default:
      return NSLocalizedString("your localised error failure reason", comment: errorDomain)
    }
  }

  static func uiErrorFrom(error: NSError) -> NSError{ //swiftlint:disable:this function_body_length
    switch error.domain {
    case "com.rest.networkService":
      switch error.code {
      default:
        print( error)
        return MarvelApiClientUiErrorBuilder.newError(error: .unhandled, underlyingError: error)
      }
    case "com.rest.restService":
      switch error.code {
      case 23: return MarvelApiClientUiErrorBuilder.newError(error: .unhandled, underlyingError: error)
      case 21: return MarvelApiClientUiErrorBuilder.newError(error: .noInternet, underlyingError: error)
      default:
        print( error)
        return MarvelApiClientUiErrorBuilder.newError(error: .unhandled, underlyingError: error)
      }
    case "com.MarvelApiClient.App":
      switch error.code {
      default:
        print( error)
        return MarvelApiClientUiErrorBuilder.newError(error: .unhandled, underlyingError: error)
      }
    case "com.MarvelApiClient.MarvelApi":
      switch error.code {
      case 32: // .noMarvelData
        print( error)
        return MarvelApiClientUiErrorBuilder.newError(error: .noInternet, underlyingError: error)
      case 34:
        print( error)
        return MarvelApiClientUiErrorBuilder.newError(error: .noInternet, underlyingError: error)
      default:
        print( error)
        return MarvelApiClientUiErrorBuilder.newError(error: .unhandled, underlyingError: error)
      }
    default:
      print( error)
      return MarvelApiClientUiErrorBuilder.newError(error: .unhandled, underlyingError: error)
    }
  }
}
