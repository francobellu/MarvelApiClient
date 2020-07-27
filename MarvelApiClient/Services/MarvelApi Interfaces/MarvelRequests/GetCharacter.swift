import Foundation
import Rest

struct GetCharacter: RestAPIRequest {

  typealias Response = [CharacterResult]

  var apiRequestConfig: ServiceConfigProtocol = MarvelApiRequestConfig()

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
