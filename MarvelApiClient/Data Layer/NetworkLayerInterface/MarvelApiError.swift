import Foundation


public enum MarvelApiError: Error, Equatable {
  public static func == (lhs: MarvelApiError, rhs: MarvelApiError) -> Bool {
    switch (lhs, rhs) {
    case (.decoding, .decoding):
      return true
    case (.noMarvelData, .noMarvelData):
      return true
    case (.insecureMD5Hash, .insecureMD5Hash):
      return true
    default:
      return false
    }
  }

  case decoding
  case noMarvelData
  case insecureMD5Hash
}


public class MarvelApiErrorBuilder {
  private static let errorDomain = "com.MarvelApiClient.MarvelApi"

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
    }
    return code
  }


  private class func localizedDescriptionForError(error: MarvelApiError) -> String {
    let returnString: String
    switch error {
    case .decoding: returnString = NSLocalizedString("your localised error description", comment: errorDomain)
    case .noMarvelData: returnString =  NSLocalizedString("your localised error description", comment: errorDomain)
    case .insecureMD5Hash: returnString =  NSLocalizedString("your localised error description", comment: errorDomain)
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
