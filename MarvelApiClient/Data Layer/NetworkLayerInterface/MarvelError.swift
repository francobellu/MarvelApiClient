import Foundation


public let marveApilErrorErrorDomain = "com.MarvelApiClient.NetworkLayer"

public enum MarvelApiError: Error {
	case decoding
  case noMarvelData
  case insecureMD5Hash
  case rest

  public static func error(underlyingError: NSError?, domain: String = marveApilErrorErrorDomain, code: Int, userInfo: [String: Any]? = nil) -> NSError {
      var localUserInfo = userInfo ?? [String: Any]()

      if underlyingError != nil {
          localUserInfo[NSUnderlyingErrorKey] = underlyingError
      }
      return NSError(domain: domain, code: code, userInfo: localUserInfo)
  }
}
