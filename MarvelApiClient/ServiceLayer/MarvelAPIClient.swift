import Foundation

protocol MarvelAPIProtocol {
  // Characters
  func getCharactersList(completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void)
  func getCharacter(with id: Int, completion: @escaping (CharacterResult) -> Void)

  // Comics
  func getComicsList(completion: @escaping ([ComicResult]) -> Void)
  func getComicsAvengers(completion: @escaping ([ComicResult]) -> Void)

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void)
}

/// Implementation of a generic-based Marvel API client
internal class MarvelAPIClient {

  // Singleton
  //static internal let shared: MarvelAPIProtocol = MarvelAPIClient(httpClient: <#HttpClient#>)

  // number of items to be fetched each time (i.e., database LIMIT)
  private let limit = 50

  // Where to start fetching items (database OFFSET). This is to support packets fetch
  private var offset = 0

  // a flag for when all database items have already been loaded
  private var reachedEndOfItems = false

  private let httpClient: HttpClient! // swiftlint:disable:this implicitly_unwrapped_optional

  init(httpClient: HttpClient) {
    self.httpClient = httpClient

  }

  private func handleGetComics(_ weakself: MarvelAPIClient,
                               _ response: (Result<DataContainer<GetComics.Response>, Error>),
                               _ completion: @escaping ([ComicResult]) -> Void  ) {
    print("\nGetCharacters list finished, limit: \(weakself.limit), offset: \(weakself.offset)")

    switch response {
    case .success(let dataContainer):

      // 3) append the new results into the data source for the tems table view
      //weakself.characters += dataContainer.results
      //guard let results = dataContainer.results else { return}
      completion(dataContainer.results)
      for comic in dataContainer.results {
        guard let thumbnail = comic.thumbnail else {return}
        print("FB:  Title: \(comic.title ?? "Unnamed character")")
        print("  Thumbnail: \(thumbnail.url.absoluteString)")
      }

      // 4) Reset the offset for the next data query
      weakself.offset += weakself.limit

      // 5) check if this was the last of the data
      if dataContainer.results.count < weakself.limit {
        weakself.reachedEndOfItems = true
        print("reached end of data. Batch count: \(dataContainer.results.count)")
      }
    case .failure(let error):
      print(error)
    }
  }
}

// Exposed API
extension MarvelAPIClient: MarvelAPIProtocol {
  func getCharacter(with id: Int, completion: @escaping (CharacterResult) -> Void ) {
    httpClient.send(GetCharacter(id: id) ) { response in
      print("\nGetCharacter \(id) finished:")
      switch response {
      case .success(let dataContainer):

        // 3) append the new results into the data source for the tems table view
        //weakself.characters += dataContainer.results
        guard let character = dataContainer.results.first,
          let thumbnail = character.thumbnail
          else{return}
        print("FB:  Title: \(character.name ?? "Unnamed character")")
        print("  Thumbnail: \(thumbnail.url.absoluteString)")

        completion(character)
      case .failure(let error):
        print(error)
      }
    }
  }

  func getCharactersList(completion: @escaping (Result<DataContainer<GetCharacters.Response>, Error>) -> Void ) {

    // Get the first <limit> characters
    httpClient.send(GetCharacters(limit: limit, offset: 0) ) { response in

      print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")

      switch response {
      case .success(let dataContainer):
        // 4) Reset the offset for the next data query
        self.offset += self.limit

        // 5) check if this was the last of the data
        if dataContainer.results.count < self.limit {
          self.reachedEndOfItems = true
          print("reached end of data. Batch count: \(dataContainer.results.count)")
        }
      case .failure(let error):
        print(error)
      }
      completion(response)
    }
  }

  func getComic(with id: Int, completion: @escaping (ComicResult) -> Void) {
    // Yet another request with a mandatory parameter
    httpClient.send(GetComic(comicId: id)) { response in
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

    httpClient.send(GetComics(format: .digital) ) { response in
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
    httpClient.send(GetComics(titleStartsWith: "Avengers", format: .digital) ) { response in
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
