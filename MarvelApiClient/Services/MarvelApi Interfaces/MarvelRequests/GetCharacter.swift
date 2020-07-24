import Foundation
import Rest

struct GetCharacter: RestAPIRequest {

  typealias Response = CharacterResult

  var apiRequestConfig: ApiRequestConfigProtocol = MarvelApiRequestConfig()

  var method: Rest.Method = .get

  var parameters: [String: String]?

  var resourceName: String {
    return "characters"
  }

  //var decode: (Data) throws -> Response

  // Note that nil parameters will not be used
  init(id: Int) {
    var params = [String: String]()
    params["id"] = String(id)
    self.parameters = params
  }
}
