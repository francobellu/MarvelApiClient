import Foundation

struct GetCharacter: APIRequest {

  typealias Response = [CharacterResult]

  var apiRequestConfig: ApiRequestConfigProtocol = MarvelApiRequestConfig()

  var resourceName: String {
    return "characters"
  }

  var method: Method = .get

  var parameters: [String: String]?

  //var decode: (Data) throws -> Response

  // Note that nil parameters will not be used
  init(id: Int) {
    var params = [String: String]()
    params["id"] = String(id)
    self.parameters = params
  }
}
