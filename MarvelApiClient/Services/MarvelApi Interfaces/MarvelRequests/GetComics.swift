import Foundation
import Rest

struct GetComics: MarvelApiRequest {

  typealias Response = [ComicResult]

  var restDependencies: RestDependenciesProtocol

  var apiRequestConfig: RestServiceConfigProtocol

  var method: RestMethod = .get

  var parameters: [String: String]?

  var resourceName: String {
    return "comics"
  }

  //var decode: (Data) throws -> Response

  enum ComicFormat: String, Encodable {
    case comic = "comic"
    case digital = "digital comic"
    case hardcover = "hardcover"
  }

  // Note that nil parameters will not be used
  init(restDependencies: RestDependenciesProtocol,
       title: String? = nil,
       titleStartsWith: String? = nil,
       format: ComicFormat? = nil,
       limit: Int? = nil,
       offset: Int? = nil) {
    self.restDependencies = restDependencies

    self.apiRequestConfig = restDependencies.apiRequestConfig

    var params = [String: String]()
    if let title = title {params["title"] = title }
    if let titleStartsWith = title {params["titleStartsWith"] = titleStartsWith }
    if let format = title {params["format"] = format }
    if let limit = title {params["limit"] = limit }
    if let offset = title {params["offset"] = offset }
    self.parameters = params
  }
}
