import Foundation
import Rest

struct GetCharacters: RestAPIRequest {

  typealias Response = CharacterResult

  var apiRequestConfig: ServiceConfigProtocol = MarvelApiRequestConfig()

  var method: Rest.Method = .get

  var parameters: [String: String]?

  var resourceName: String {
    return "characters"
  }

  //var decode: (Data) throws -> Response

  // Note that nil parameters will not be used
  init(name: String? = nil,
       nameStartsWith: String? = nil,
       limit: Int? = nil,
       offset: Int? = nil) {

    var params = [String: String]()
    if let name = name {params["name"] = name}
    if let nameStartsWith = nameStartsWith {params["nameStartsWith"] = nameStartsWith}
    if let limit = limit { params["limit"] = String(limit) }
    if let offset = offset { params["offset"] = String(offset)}
    self.parameters = params
  }
}
