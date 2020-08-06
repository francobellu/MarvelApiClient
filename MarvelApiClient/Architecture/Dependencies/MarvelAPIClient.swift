import Foundation

/// Implementation of a generic-based Marvel API client
class MarvelApiClient: MarvelApiProtocol {

  // number of items to be fetched each time (i.e., database LIMIT)
  private let limit = 50

  // Where to start fetching items (database OFFSET). This is to support packets fetch
  private var offset = 0

  // a flag for when all database items have already been loaded
  private var reachedEndOfItems = false

  private let restDependencies: RestDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  init(restDependencies: RestDependenciesProtocol) {
    self.restDependencies = restDependencies
  }

  // Todo: not used
  private func executeRequestLogic(count: Int){
    // Reset the offset for the next data query
    self.offset += self.limit
    // Check if this was the last of the data
    if count < self.limit {
      self.reachedEndOfItems = true
      print("reached end of data. Batch count: \(count)")
    }
  }

  func getCharactersList(completion: @escaping (Result<GetCharacters.Response, Error>) -> Void) {
    // Get the first <limit> characters
    let request = GetCharacters( restDependencies: restDependencies, limit: limit, offset: 0)
    guard let url = request.apiRequestConfig.buildEndpointUrlFor(resourceName: request.resourceName, parameters: request.parameters) else {return }
    let urlRequest = URLRequest(url: url)

    restDependencies.restApiClient.send(urlRequest ) { (result) in
      print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")
      var completionResult: Result<GetCharacters.Response, Error>

      switch result {
      case .success((_, let data)):
        completionResult = request.decode(data)
      case .failure(let error):
        completionResult = .failure(error)
      }
      completion(completionResult)
    }
//    restDependencies.marvel.send(request ) { result in
//      print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")


//      switch result {
//      case .success((_, let data)):
////        let dataContaineResult = decodeResponseDataToMarvelResponse(data: data, request: request)
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
  }

  func getCharacter(with id: Int, completion: @escaping (Result<GetCharacter.Response, Error>) -> Void) {

    let request = GetCharacter(restDependencies: restDependencies, id: id)
    guard let url = request.apiRequestConfig.buildEndpointUrlFor(resourceName: request.resourceName, parameters: request.parameters) else {return }
    let urlRequest = URLRequest(url: url)

    restDependencies.restApiClient.send(urlRequest)  { (result) in
     print("\nGetCharacter \(id) finished")
     var completionResult: Result<GetCharacters.Response, Error>
      switch result {
      case .success((_, let data)):
        completionResult = request.decode(data)
      case .failure(let error):
        completionResult = .failure(error)
      }
      completion(completionResult)
    }
  }
//
//   private func handleSuccessResultsGetCharacter(_ data: Data, request: GetCharacter) -> Result<[CharacterResult], Error> {
//      let returnValue: Result<[CharacterResult], Error>
//
//      let dataContaineResult = decodeResponseDataToMarvelResponse(data: data, request: request)
//      switch dataContaineResult{
//      case .success(let dataContainer):
//        let characters = dataContainer.results
//        returnValue = .success(characters)
//      case .failure(let error):
//        returnValue = .failure(error)
//      }
//      return returnValue
//    }
//
//  // Handle decoding errors and situation where the response object MarvelResponse dones't have a .data field
//  private func decodeResponseDataToMarvelResponse<T: RestAPIRequest> (data: Data, request: T) -> Result<DataContainer<T.Response>, Error> {
//    var result: Result<DataContainer<T.Response>, Error>
//    do {
//      let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)
//      if let dataContainer = marvelResponse.data {
//        result = .success(dataContainer)
//      } else {
//        result = .failure(MarvelError.noData)
//      }
//    } catch {
//      let marvelError = try? JSONDecoder().decode(ErrorResponse.self, from: data)
//      result = .failure(MarvelError.server(message: "Error code: \(String(describing: marvelError?.code)), message: \(String(describing: marvelError?.message))"))
//    }
//    return result
}



//// Exposed API
//extension MarvelApiClient: MarvelApiProtocol {
//
//  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
//    fatalError()
//  }
//
//  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
//    fatalError()
//  }
//}

//  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
//    // Yet another request with a mandatory parameter
//    restApiClient.send(GetComic(comicId: id)) { response in
//      print("\nGetComic \(id) finished:")
//
//      switch response {
//      case .success(let dataContainer):
//        guard let comic = dataContainer.results.first else {return}
//        if let title = comic.title,
//          let thumbnail = comic.thumbnail{
//          print("  Title: \(title)")
//          print("  Thumbnail: \(thumbnail.url.absoluteString)")
//        }
//        completion(comic)
//      case .failure(let error):
//        print(error)
//      }
//    }
//  }
//
//  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
//    // 1) Don't bother doing another db query if already have everything
//    guard !reachedEndOfItems else {
//      return
//    }
//
//    restApiClient.send(GetComics(format: .digital) ) { response in
//      print("\nGetComics finished:")
//      switch response {
//      case .success(let dataContainer):
//        for comic in dataContainer.results {
//
//          let title = comic.title
//          if let thumbnail = comic.thumbnail{
//
//            print("  Title: \(String(describing: title))")
//            print("  Thumbnail: \(thumbnail.url.absoluteString )")
//          }
//        }
//        completion(dataContainer.results)
//
//      case .failure(let error):
//        print(error)
//      }
//    }
//  }
//
//  func getComicsAvengers(completion: @escaping ([ComicResult]) -> Void) {
//    // Another request filling interesting optional parameters, a string and an enum
//    restApiClient.send(GetComics(titleStartsWith: "Avengers", format: .digital) ) { response in
//      print("\nGetComics starting with  \"Avengers\" finished:")
//
//      switch response {
//      case .success(let dataContainer):
//        for comic in dataContainer.results {
//
//          if let title = comic.title,
//            let thumbnail = comic.thumbnail{
//            print("  Title: \(title)")
//            print("  Thumbnail: \(thumbnail.url.absoluteString)")
//          }
//        }
//        completion(dataContainer.results)
//
//      case .failure(let error):
//        print(error)
//      }
//    }
//  }
//}
