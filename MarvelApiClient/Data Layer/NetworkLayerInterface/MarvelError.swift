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

//  public static func error(underlyingError: NSError?, domain: String = marveApilErrorErrorDomain, code: Int, userInfo: [String: Any]? = nil) -> NSError {
//    var localUserInfo = userInfo ?? [String: Any]()
//
//    if underlyingError != nil {
//      localUserInfo[NSUnderlyingErrorKey] = underlyingError
//    }
//    return NSError(domain: domain, code: code, userInfo: localUserInfo)
//  }

  public static func error(underlyingError: NSError?, domain: String = marveApilErrorErrorDomain, userInfo: [String: Any]? = nil) -> NSError {
    var localUserInfo = userInfo ?? [String: Any]()

    if underlyingError != nil {
      localUserInfo[NSUnderlyingErrorKey] = underlyingError
    }
    return NSError(domain: domain, code: 0, userInfo: localUserInfo)
  }

  private static func userInfos(networkError: MarvelApiError) -> [String: Any] {
    var userInfo = [String: Any]()
    userInfo[NSLocalizedDescriptionKey] = MarvelApiError.localizedDescriptionForCode(networkError: networkError)
    userInfo[NSLocalizedFailureReasonErrorKey] = MarvelApiError.failureReasonForCode(networkError: networkError)
    return userInfo
  }

  private static func localizedDescriptionForCode(networkError: MarvelApiError) -> String {
    switch networkError {
    case .decoding:
      return NSLocalizedString("your localised error description", comment: marveApilErrorErrorDomain)
    case .noMarvelData:
      return NSLocalizedString("your localised error description", comment: marveApilErrorErrorDomain)
    case .insecureMD5Hash:
      return NSLocalizedString("No Internet", comment: marveApilErrorErrorDomain)
    case .restService:
      return NSLocalizedString("your localised error description", comment: marveApilErrorErrorDomain)
    }
  }

  private static func failureReasonForCode(networkError: MarvelApiError) -> String {
    switch self {
      //    case AppErrorCode.anErrorCase.rawValue:
    //      return NSLocalizedString("your localised error failure reason", comment: "ModuleName")
    default:
      return NSLocalizedString("your localised error failure reason", comment: marveApilErrorErrorDomain)
    }
  }
}
