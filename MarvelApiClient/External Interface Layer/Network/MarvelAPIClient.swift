import Foundation
import Rest

protocol MarvelApiProtocol {
  // Characters
  func getCharactersList(completion: @escaping (Result<[CharacterResult], Error>) -> Void)
  func getCharacter(with id: Int, completion:  @escaping (Result<[CharacterResult], Error>) -> Void)
}

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

  func getCharactersList(completion: @escaping (Result<[CharacterResult], Error>) -> Void){
    // Get the first <limit> characters
//    let request = APIRequests.getCharactersList()
    let query = CharactersQuery(name: nil, nameStartsWith: nil, limit: 50, offset: 0)
    let request = GetCharactersListReq(query: query)
    do {
      // TODO: handle error
       restDependencies.restService.request(with: request ) { (result) in
        print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")
        var completionResult: Result<[CharacterResult], Error>

        switch result {
        case .success(let data):
//          let dataXX = data as [CharacterResult]
          completionResult =  .success(data) //request.decode(dataXX)
        case .failure(let error):
          completionResult = .failure(error)
        }
        completion(completionResult)
      }
    } catch  {
      completion(.failure(RequestGenerationError.components))
    }
  }

  func getCharacter(with id: Int, completion:  @escaping (Result<[CharacterResult], Error>) -> Void){

//    let request = GetCharacter(restDependencies: restDependencies, id: id)
//    var urlRequest: URLRequest

    let request = APIRequests.getCharactersList()
    do {
       try restDependencies.restService.request(with: request)  { (result) in
        print("\nGetCharacter \(id) finished")
        var completionResult: Result<[CharacterResult], Error>
        switch result {
        case .success(let data):
          completionResult = .success(data) //request.decode(data)
        case .failure(let error):
          completionResult = .failure(error)
        }
        completion(result)
      }
    } catch  {
      completion(.failure(RequestGenerationError.components))
    }
  }



  // Strips any wrapper around the requested object
//  public func extractApiObjectFrom(_ data: Data) -> Result<Response, Error> {
//    let dataContaineResult = self.decodeToMarvelResponseWrapper(data)
//    return stripDataContainerFrom(dataContaineResult)
//  }
//
////   Strips the MarvelApiResponse wrapper and returns a DataContainer object if exists
//    private func decodeToMarvelResponseWrapper (_ data: Data) -> Result<DataContainer<Response>, Error> {
//      var result: Result<DataContainer<Response>, Error>
//      do {
//        let marvelResponse = try JSONDecoder().decode(MarvelResponse<Response>.self, from: data)
//        if let dataContainer = marvelResponse.data {
//          result = .success(dataContainer)
//        } else {
//          result = .failure(MarvelError.noData)
//        }
//      } catch {
//        // decode the ErrorResponse
//        _ = try? JSONDecoder().decode(ErrorResponse.self, from: data)
//        result = .failure(MarvelError.decoding)
//      }
//      return result
//    }
//
//    //  Strips the DataContainer wrapper and returns a Response object if exists
//    private func stripDataContainerFrom(_ dataContaineResult: Result<DataContainer<Response>, Error>) -> Result<Response, Error> {
//      let returnValue: Result<Response, Error>
//      switch dataContaineResult{
//      case .success(let dataContainer):
//        let resultObject = dataContainer.results
//        returnValue = .success(resultObject)
//      case .failure(let error):
//        returnValue = .failure(error)
//      }
//      return returnValue
//    }
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
//    httpService.send(GetComic(comicId: id)) { response in
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
//    httpService.send(GetComics(format: .digital) ) { response in
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
//    httpService.send(GetComics(titleStartsWith: "Avengers", format: .digital) ) { response in
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
