import Foundation


/// Implementation of a generic-based Marvel API client
internal class MarvelApiClient {

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
}

// Exposed API
extension MarvelApiClient: MarvelApiProtocol {
   func getCharactersList(completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void) {


    // Get the first <limit> characters
    restApiClient.send(GetCharacters(limit: limit, offset: 0) ) { result in

      print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")

      switch result {
      case .success(let dataContainer):
        // 4) Reset the offset for the next data query
        self.offset += self.limit

        // 5) check if this was the last of the data
        if dataContainer.results.count < self.limit {
          self.reachedEndOfItems = true
          print("reached end of data. Batch count: \(dataContainer.results.count)")
        }
        completion(result)
      case .failure(let error):
        print(error)
        completion(result)
      }
    }
  }

  func getCharacter(with id: Int, completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void) {
    restApiClient.send(GetCharacter(id: id) ) { response in
      print("\nGetCharacter \(id) finished:")
      completion(response)
    }
  }

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
    // Yet another request with a mandatory parameter
    restApiClient.send(GetComic(comicId: id)) { response in
      print("\nGetComic \(id) finished:")

      switch response {
      case .success(let dataContainer):
        guard let comic = dataContainer.results.first else {return}
        if let title = comic.title,
          let thumbnail = comic.thumbnail{
          print("  Title: \(title)")
          print("  Thumbnail: \(thumbnail.url.absoluteString)")
        }
        completion(comic)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getComicsList(completion: @escaping ([ComicResult]) -> Void) {
    // 1) Don't bother doing another db query if already have everything
    guard !reachedEndOfItems else {
      return
    }

    restApiClient.send(GetComics(format: .digital) ) { response in
      print("\nGetComics finished:")
      switch response {
      case .success(let dataContainer):
        for comic in dataContainer.results {

          let title = comic.title
          if let thumbnail = comic.thumbnail{

            print("  Title: \(String(describing: title))")
            print("  Thumbnail: \(thumbnail.url.absoluteString )")
          }
        }
        completion(dataContainer.results)

      case .failure(let error):
        print(error)
      }
    }
  }

  func getComicsAvengers(completion: @escaping ([ComicResult]) -> Void) {
    // Another request filling interesting optional parameters, a string and an enum
    restApiClient.send(GetComics(titleStartsWith: "Avengers", format: .digital) ) { response in
      print("\nGetComics starting with  \"Avengers\" finished:")

      switch response {
      case .success(let dataContainer):
        for comic in dataContainer.results {

          if let title = comic.title,
            let thumbnail = comic.thumbnail{
            print("  Title: \(title)")
            print("  Thumbnail: \(thumbnail.url.absoluteString)")
          }
        }
        completion(dataContainer.results)

      case .failure(let error):
        print(error)
      }
    }
  }
}
