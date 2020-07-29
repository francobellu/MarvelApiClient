import Foundation
import Rest

struct GetComic: MarvelApiRequest {
  typealias Response = ComicResult

  var restDependencies: RestDependenciesProtocol

  var apiRequestConfig: RestServiceConfigProtocol

  var method: RestMethod = .get

  var parameters: [String: String]?

  //var decode: (Data) throws -> Response

  var resourceName: String {
    return "comics/\(comicId)"
  }

  private let comicId: Int

  init(restDependencies: RestDependenciesProtocol, comicId: Int) {
    self.restDependencies = restDependencies

    self.apiRequestConfig = restDependencies.apiRequestConfig

    self.comicId = comicId
    var params = [String: String]()
    params["comicId"] = String(comicId)
    self.parameters = params
  }

//  func execute(completion: @escaping (Result<Response, Error>) -> Void) {
//    // Yet another request with a mandatory parameter
//    restApiClient.send(self) { result in
////      print("\nGetComic \(id) finished:")
//      var completionValue: Result<Response, Error>
//      switch result {
//      case .success((_, let data)):
//        let dataContaineResult = self.decodeResponseDataToMarvelResponse(data: data, request: self)
//        switch dataContaineResult{
//        case .success(let dataContainer):
//          completionValue = .success(dataContainer.results)
//        case .failure(let error):
//          completionValue = .failure(error)
//        }
//      case .failure(let error):
//        completionValue = .failure(error)
//      }
//      completion(completionValue)
//    }
//  }
}
