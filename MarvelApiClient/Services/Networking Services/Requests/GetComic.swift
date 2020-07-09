import Foundation

struct GetComic: APIRequest {
  typealias Response = ComicResult

  var apiRequestConfig: ApiRequestConfigProtocol = MarvelApiRequestConfig()

  var method: Method = .get

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
}
