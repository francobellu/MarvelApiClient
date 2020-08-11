import Foundation

struct GetCharacters: MarvelApiRequest {

  typealias Response = [CharacterResult]

  var restDependencies: RestDependenciesProtocol

  var method: RestMethod = .get

  var urlParameters: [String: String]?

  var encodableUrlParameters: Encodable? = nil

  var headerParamaters: [String: String]?

  var bodyParameters: [String: String]? = nil

  var encodableBodyParamaters: Encodable? = nil

  var bodyEncoding: BodyEncoding? = nil

  var resourceName: String {
    return "characters"
  }

  //var decode: (Data) throws -> Response

  // Note that nil parameters will not be used
  init( restDependencies: RestDependenciesProtocol,
        name: String? = nil,
        nameStartsWith: String? = nil,
        limit: Int? = nil,
        offset: Int? = nil) {

    self.restDependencies = restDependencies

    urlParameters = restDependencies.apiConfig.urlParameters

    if let name = name {urlParameters?["name"] = name}
    if let nameStartsWith = nameStartsWith {urlParameters?["nameStartsWith"] = nameStartsWith}
    if let limit = limit { urlParameters?["limit"] = String(limit) }
    if let offset = offset { urlParameters?["offset"] = String(offset)}

  }

  init( restDependencies: RestDependenciesProtocol,
        name: String? = nil, query: CharactersQuery ) {

    self.restDependencies = restDependencies
//    apiRequestConfig = restDependencies.apiRequestConfig

    var params = [String: String]()
    if let name = name {params["name"] = name}
    if let nameStartsWith = query.nameStartsWith {params["nameStartsWith"] = nameStartsWith}
    if let limit = query.limit { params["limit"] = String(limit) }
    if let offset = query.offset { params["offset"] = String(offset)}
    self.urlParameters = params
  }
//
//  func getCharactersList(completion: @escaping (Result<Response, Error>) -> Void) {
//    // Get the first <limit> characters
////    let request = GetCharacters(limit: limit, offset: 0)
//    httpService.send(self ) { result in
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
