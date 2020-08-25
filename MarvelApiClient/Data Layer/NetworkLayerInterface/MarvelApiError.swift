import Foundation

public let marveApilErrorErrorDomain = "com.MarvelApiClient.MarvelApi"

public enum MarvelApiError: Error, Equatable {
  public static func == (lhs: MarvelApiError, rhs: MarvelApiError) -> Bool {
    switch (lhs, rhs) {
    case (.decoding, .decoding):
      return true
    case (.noMarvelData, .noMarvelData):
      return true
    case (.insecureMD5Hash, .insecureMD5Hash):
      return true
//    case (.restService( let errorA), .restService(let errorB) ) where  errorA == errorB:
//      return true
    case (.restService, .restService):
        return true
    default:
      return false
    }
  }

  case decoding
  case noMarvelData
  case insecureMD5Hash
  case restService(NSError)
}


public class MarvelApiErrorBuilder {
  private static let errorDomain = marveApilErrorErrorDomain

  public static func newError(error: MarvelApiError, underlyingError: NSError? = nil) -> NSError {
    var userInfo = [String: Any]()
    userInfo[NSUnderlyingErrorKey] = underlyingError
    userInfo[NSLocalizedDescriptionKey] = localizedDescriptionForError(error: error)
    userInfo[NSLocalizedFailureReasonErrorKey] = failureReasonForError(error: error)

    let code = codeForError(error)
    return NSError(domain: errorDomain, code: code, userInfo: userInfo)
  }

  private static func codeForError(_ error: MarvelApiError) -> Int {
    let code: Int
    switch error {
    case .decoding: code =  31
    case .noMarvelData: code =  32
    case .insecureMD5Hash: code =  33
    case .restService: code =  34
    }
    return code
  }


  private class func localizedDescriptionForError(error: MarvelApiError) -> String {
    let returnString: String
    switch error {
    case .decoding: returnString = NSLocalizedString("your localised error description", comment: errorDomain)
    case .noMarvelData: returnString =  NSLocalizedString("your localised error description", comment: errorDomain)
    case .insecureMD5Hash: returnString =  NSLocalizedString("your localised error description", comment: errorDomain)
    case .restService: returnString =  NSLocalizedString("your localised error description", comment: errorDomain)
    }
    return returnString
  }

  private class func failureReasonForError(error: MarvelApiError) -> String {
    switch error {
//    case AppErrorCode.anErrorCase.rawValue:
//      return NSLocalizedString("your localised error failure reason", comment: "ModuleName")
    default:
       return NSLocalizedString("your localised error failure reason", comment: errorDomain)
    }
  }
}

//  public static func error(underlyingError: NSError?, domain: String = marveApilErrorErrorDomain, code: Int, userInfo: [String: Any]? = nil) -> NSError {
//    var localUserInfo = userInfo ?? [String: Any]()
//
//    if underlyingError != nil {
//      localUserInfo[NSUnderlyingErrorKey] = underlyingError
//    }
  //    return NSError(domain: domain, code: code, userInfo: localUserInfo)
  //  }
//
//
//  public static func error(error: MarvelApiError ,underlyingError: NSError?, domain: String = marveApilErrorErrorDomain, userInfo: [String: Any]? = nil) -> NSError {
//    var localUserInfo = userInfo ?? [String: Any]()
//
//    if underlyingError != nil {
//      localUserInfo[NSUnderlyingErrorKey] = underlyingError
//    }
//
//    let code = codeForError( error)
//    return NSError(domain: domain, code:code , userInfo: localUserInfo)
//  }
//
//  private static func codeForError(_ error: MarvelApiError) -> Int {
//    let code: Int
//    switch error {
//    case .decoding: code =  11
//    case .noMarvelData: code =  12
//    case .insecureMD5Hash: code =  13
//    case .restService: code =  14
//    }
//    return code
//  }
//
//  private static func userInfos(networkError: MarvelApiError) -> [String: Any] {
//    var userInfo = [String: Any]()
//    userInfo[NSLocalizedDescriptionKey] = MarvelApiError.localizedDescriptionForCode(networkError: networkError)
//    userInfo[NSLocalizedFailureReasonErrorKey] = MarvelApiError.failureReasonForCode(networkError: networkError)
//    return userInfo
//  }
//
//  private static func localizedDescriptionForCode(networkError: MarvelApiError) -> String {
//    switch networkError {
//    case .decoding:
//      return NSLocalizedString("your localised error description", comment: marveApilErrorErrorDomain)
//    case .noMarvelData:
//      return NSLocalizedString("your localised error description", comment: marveApilErrorErrorDomain)
//    case .insecureMD5Hash:
//      return NSLocalizedString("No Internet", comment: marveApilErrorErrorDomain)
//    case .restService:
//      return NSLocalizedString("your localised error description", comment: marveApilErrorErrorDomain)
//    }
//  }
//
//  private static func failureReasonForCode(networkError: MarvelApiError) -> String {
//    switch self {
//      //    case AppErrorCode.anErrorCase.rawValue:
//    //      return NSLocalizedString("your localised error failure reason", comment: "ModuleName")
//    default:
//      return NSLocalizedString("your localised error failure reason", comment: marveApilErrorErrorDomain)
//    }
//  }
//}
