import Foundation

/// Dumb error to model simple errors
/// In a real implementation this should be more exhaustive
public enum MarvelError: Error {
  case none
//  case encoding
	case decoding
  case noMarvelData
//	case server(message: String)
  case insecureMD5Hash
  case rest
}
