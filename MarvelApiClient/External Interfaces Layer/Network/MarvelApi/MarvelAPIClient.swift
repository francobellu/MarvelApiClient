import Foundation
import Rest

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
  private func executeRequestLogic(count: Int) {
    // Reset the offset for the next data query
    self.offset += self.limit
    // Check if this was the last of the data
    if count < self.limit {
      self.reachedEndOfItems = true
      print("reached end of data. Batch count: \(count)")
    }
  }

  func getCharactersList(completion: @escaping (Result<[CharacterResult], MarvelError>) -> Void) {
    let query = CharactersQuery(name: nil, nameStartsWith: nil, limit: 50, offset: 0)
    let request = MarvelApiRequest<[CharacterResult]>.makeCharactersListRequest(from: query) // GetCharactersListReq(query: query)
    do {
      // TODO: handle error
       restDependencies.restService.request(with: request ) { (result) in
        print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")
        var completionResult: Result<[CharacterResult], MarvelError> = .failure(.none)

        switch result {
        case .success(let data):
          completionResult = .success(data)
        case .failure:
//          if case RestServiceError.decoding = error { completionResult = .failure(.rest)}
          completionResult = .failure(.rest)
        }
        completion(completionResult)
      }
    }
    //    catch  {
    //      completion(.failure(RestApiRequestError.malformedUrl))
    //    }
  }

  func getCharacter(with id: Int, completion:  @escaping (Result<[CharacterResult], MarvelError>) -> Void) {

    let query = CharacterQuery(id: id)
    let request = MarvelApiRequest<[CharacterResult]>.makeCharacterRequest(from: query)
    do {
      restDependencies.restService.request(with: request) { (result) in
        print("\nGetCharacter \(id) finished")
        var completionResult: Result<[CharacterResult], MarvelError> = .failure(.none)
        switch result {
        case .success(let data):
          completionResult = .success(data) //request.decode(data)
        case .failure:
         completionResult = .failure(.rest)
        }
        completion(completionResult)
      }
    }
    //    catch  {
    //      completion(.failure(RestServiceError.))
    //    }
  }
}
