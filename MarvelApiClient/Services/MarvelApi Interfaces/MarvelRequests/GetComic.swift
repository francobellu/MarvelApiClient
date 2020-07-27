import Foundation
import Rest

struct GetComic: RestAPIRequest {
  typealias Response = ComicResult

  var apiRequestConfig: ServiceConfigProtocol = MarvelApiRequestConfig()

  var method: Rest.Method = .get

  var parameters: [String: String]?

  //var decode: (Data) throws -> Response

  var resourceName: String {
    return "comics/\(comicId)"
  }

  private let comicId: Int

  init(comicId: Int) {
    self.comicId = comicId
    var params = [String: String]()
    params["comicId"] = String(comicId)
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
