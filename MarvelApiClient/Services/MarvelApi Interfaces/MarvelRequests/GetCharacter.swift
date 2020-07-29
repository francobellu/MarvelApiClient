import Foundation
import Rest

struct GetCharacter: MarvelApiRequest {

  typealias Response = [CharacterResult]

  var restDependencies: RestDependenciesProtocol

  var apiRequestConfig: RestServiceConfigProtocol

  var method: RestMethod = .get

  var parameters: [String: String]?

  var resourceName: String {
    return "characters"
  }

  //var decode: (Data) throws -> Response

  // Note that nil parameters will not be used
  init(restDependencies: RestDependenciesProtocol, id: Int) {

    self.restDependencies = restDependencies

    self.apiRequestConfig = restDependencies.apiRequestConfig

    var params = [String: String]()
    params["id"] = String(id)
    self.parameters = params
  }
}
