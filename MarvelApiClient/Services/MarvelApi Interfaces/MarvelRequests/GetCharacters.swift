import Foundation
import Rest

struct GetCharacters: MarvelApiRequest {

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
  init(restDependencies: RestDependenciesProtocol,
       name: String? = nil,
       nameStartsWith: String? = nil,
       limit: Int? = nil,
       offset: Int? = nil) {

    self.restDependencies = restDependencies

    self.apiRequestConfig = restDependencies.apiRequestConfig

    var params = [String: String]()
    if let name = name {params["name"] = name}
    if let nameStartsWith = nameStartsWith {params["nameStartsWith"] = nameStartsWith}
    if let limit = limit { params["limit"] = String(limit) }
    if let offset = offset { params["offset"] = String(offset)}
    self.parameters = params
  }
//
//  func getCharactersList(completion: @escaping (Result<Response, Error>) -> Void) {
//    // Get the first <limit> characters
////    let request = GetCharacters(limit: limit, offset: 0)
//    restApiClient.send(self ) { result in
////      print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")
//
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
//
//      case .failure(let error):
//        completionValue = .failure(error)
//      }
//      completion(completionValue)
//    }
//  }
}
