import Foundation
import Rest

struct GetComics: RestAPIRequest {
  typealias Response = ComicResult

  var apiRequestConfig: ServiceConfigProtocol = MarvelApiRequestConfig()

  var method: Rest.Method = .get

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

  func decode(_ data: Data) -> Result<Response, Error> {
    var result: Result<Response, Error>
    do {
      let marvelResponse = try JSONDecoder().decode(MarvelResponse<Response>.self, from: data)
      if let dataContainer = marvelResponse.data {
        let characters = dataContainer.results
        result = .success(characters)
      } else {
        result = .failure(MarvelError.noData)
      }
    } catch {
      _ = try? JSONDecoder().decode(ErrorResponse.self, from: data)
      result = .failure(MarvelError.decoding)
    }
    return result
  }
}
