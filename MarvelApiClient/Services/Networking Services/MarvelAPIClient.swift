import Foundation


/// Implementation of a generic-based Marvel API client
class MarvelApiClient {

  // number of items to be fetched each time (i.e., database LIMIT)
  private let limit = 50

  // Where to start fetching items (database OFFSET). This is to support packets fetch
  private var offset = 0

  // a flag for when all database items have already been loaded
  private var reachedEndOfItems = false

  private let restApiClient: RestApiClient! // swiftlint:disable:this implicitly_unwrapped_optional

  init(restApiClient: RestApiClient) {
    self.restApiClient = restApiClient

  }
  private func executeRequestLogic(count: Int){
    // Reset the offset for the next data query
    self.offset += self.limit
    // Check if this was the last of the data
    if count < self.limit {
      self.reachedEndOfItems = true
      print("reached end of data. Batch count: \(count)")
    }
  }

  private func decode<T: APIRequest> (data: Data, request: T) -> Result<DataContainer<T.Response>, Error> {

      var result: Result<DataContainer<T.Response>, Error>
      // TODO response unused??
      do {
        let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)
        if let dataContainer = marvelResponse.data {
          result = .success(dataContainer)
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


//  private func decode<T: APIRequest> (data: Data) -> Result<DataContainer<T.Response>, Error> {
//
//    var result: Result<DataContainer<T.Response>, Error>
//    // TODO response unused??
//    do {
//      // debug: print json data before to decode
//      print(data)
//      let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//      print("Data: \(data),  json: \(jsonData)")
//      let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)
//      print("FB: marvelResponse: \(marvelResponse)")
//      if let dataContainer = marvelResponse.data {
//        result = .success(dataContainer)
//      } else {
//        result = .failure(MarvelError.noData)
//      }
//    } catch {
//      _ = try? JSONDecoder().decode(ErrorResponse.self, from: data)
//      result = .failure(MarvelError.decoding)
//    }
//    return result
//  }
//}

// Exposed API
extension MarvelApiClient: MarvelApiProtocol {
  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
    fatalError()
  }

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
    fatalError()
  }

  func getCharactersList(completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void) {
    // Get the first <limit> characters
    let request = GetCharacters(limit: limit, offset: 0)
    restApiClient.send(request ) { result in
      print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")

      var completionValue: Result<DataContainer<GetCharacters.Response>, Error>
      switch result {
      case .success((_, let data)):
        completionValue = self.decode(data: data, request: request)
      case .failure(let error):
        completionValue = .failure(error)
      }
      completion(completionValue)
    }
  }

  func getCharacter(with id: Int, completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void) {

    let request = GetCharacter(id: id)
    restApiClient.send(request ) { result in
      print("\nGetCharacter \(id) finished:")

      var completionValue: Result<DataContainer<GetCharacters.Response>, Error>
      switch result {
      case .success((_, let data)):
        completionValue = self.decode(data: data, request: request)
      case .failure(let error):
        completionValue = .failure(error)
      }
      completion(completionValue)
    }
  }
}

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
