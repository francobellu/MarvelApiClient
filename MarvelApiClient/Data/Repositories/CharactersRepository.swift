//
//  CharactersRepository.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation


final class DefaultCharactersRepository {

//    private let dataTransferService: DataTransferService
//    private let cache: MoviesResponseStorage
//
//    init(dataTransferService: DataTransferService, cache: MoviesResponseStorage) {
//        self.dataTransferService = dataTransferService
//        self.cache = cache
//    }
}

extension DefaultCharactersRepository: CharactersRepository {
  func getCharactersList(completion: @escaping (Result<CharacterResult, Error>) -> Void) {
//    let requestDTO = CharactersRequestDTO(query: query.query, page: page)
//        let task = RepositoryTask()
//
//        cache.getResponse(for: requestDTO) { result in
//
//            if case let .success(responseDTO?) = result {
//                cached(responseDTO.toDomain())
//            }
//            guard !task.isCancelled else { return }
//
//            let endpoint = APIEndpoints.getMovies(with: requestDTO)
//            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
//                switch result {
//                case .success(let responseDTO):
//                    self.cache.save(response: responseDTO, for: requestDTO)
//                    completion(.success(responseDTO.toDomain()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//        }
//        return task
//    }
  }
}
