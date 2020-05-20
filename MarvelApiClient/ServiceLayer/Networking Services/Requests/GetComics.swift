import Foundation

struct GetComics: APIRequest {
	typealias Response = [ComicResult]

  var apiRequestConfig: ApiRequestConfigProtocol = MarvelApiRequestConfig()

  var method: Method = .get

  var parameters: [String: String]?

  //var decode: (Data) throws -> Response

  var resourceName: String {
    return "comics"
  }

  enum ComicFormat: String, Encodable {
    case comic = "comic"
    case digital = "digital comic"
    case hardcover = "hardcover"
  }

  // Note that nil parameters will not be used
  init(title: String? = nil,
       titleStartsWith: String? = nil,
       format: ComicFormat? = nil,
       limit: Int? = nil,
       offset: Int? = nil) {
    var params = [String: String]()
    if let title = title {params["title"] = title }
    if let titleStartsWith = title {params["titleStartsWith"] = titleStartsWith }
    if let format = title {params["format"] = format }
    if let limit = title {params["limit"] = limit }
    if let offset = title {params["offset"] = offset }
    self.parameters = params
  }
}
