import Foundation

struct GetCharacter: MarvelApiRequest {

  typealias Response = [CharacterResult]

  var restDependencies: RestDependenciesProtocol

  var method: RestMethod = .get

  var urlParameters: [String: String]? = nil

  var encodableUrlParameters: Encodable? = nil

  var headerParamaters: [String: String]? = nil

  var bodyParameters: [String: String]? = nil

  var encodableBodyParamaters: Encodable? = nil

  var bodyEncoding: BodyEncoding? = nil

  var resourceName: String {
    return "characters"
  }

  //var decode: (Data) throws -> Response

  // Note that nil parameters will not be used
  init( restDependencies: RestDependenciesProtocol, id: Int) {

    self.restDependencies = restDependencies

    urlParameters = [:]
    urlParameters?["id"] = String(id)
  }
}
