import Foundation

struct GetCharacters: APIRequest {
  typealias Response = [CharacterResult]

  var apiRequestConfig: ApiRequestConfigProtocol = MarvelApiRequestConfig()

  var method: Method = .get

  var parameters: [String: String]?

  //var decode: (Data) throws -> Response

  var resourceName: String {
    return "characters"
  }

  // Note that nil parameters will not be used
  init(name: String? = nil,
       nameStartsWith: String? = nil,
       limit: Int? = nil,
       offset: Int? = nil) {

    var params = [String: String]()
    params["name"] = name
    params["nameStartsWith"] = nameStartsWith
    if let limit = limit { params["limit"] = String(limit) }
    if let offset = offset { params["offset"] = String(offset)}
    self.parameters = params
  }
}
