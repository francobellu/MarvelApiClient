import Foundation
import Rest

/// Implementation of a generic-based Marvel API client
class MarvelApiClient: MarvelApiProtocol {

  // number of items to be fetched each time (i.e., database LIMIT)
  private let limit = 20

  // Where to start fetching items (database OFFSET). This is to support packets fetch
  private var offset = 0

  // a flag for when all database items have already been loaded
  private var reachedEndOfItems = false

  private let restDependencies: RestDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  init(restDependencies: RestDependenciesProtocol) {
    self.restDependencies = restDependencies
  }

  // Todo: not used
  private func executeRequestLogic(_ charactersCount: Int) {
    // Reset the offset for the next data query
    self.offset += self.limit
    // Check if this was the last of the data
    if charactersCount < self.limit {
      self.reachedEndOfItems = true
      print("reached end of data. Batch count: \(charactersCount)")
    }
  }

  func getCharactersList(completion: @escaping (Result<[CharacterResult], Error>) -> Void) {
    let query = CharactersQuery(name: nil, nameStartsWith: nil, limit: limit, offset: offset)
    let request = MarvelApiRequest<[CharacterResult]>.makeCharactersListRequest(from: query)
    // TODO: handle error
    restDependencies.restService.request(with: request ) { result in
      print("\nGetCharacters list finished, limit: \(self.limit), offset: \(self.offset)")
      do {
        let characters: [CharacterResult] = try result.get()
        self.executeRequestLogic(characters.count)
        completion(.success( characters) )
      } catch let restServiceError  {
        completion(.failure(restServiceError))
      }
    }
  }

  func getCharacter(with id: Int, completion:  @escaping (Result<[CharacterResult], Error>) -> Void) {

    let query = CharacterQuery(id: id)
    let request = MarvelApiRequest<[CharacterResult]>.makeCharacterRequest(from: query)
    do {
      restDependencies.restService.request(with: request) { (result) in
        print("\nGetCharacter \(id) finished")

        do {
          completion(.success( try result.get()))
        } catch let restServiceError {
          completion(.failure(restServiceError))
        }
      }
    }
  }
}
