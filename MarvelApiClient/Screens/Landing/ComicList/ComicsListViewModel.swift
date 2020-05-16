//
//  ComicsListViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class ComicsListViewModel {

  // THE STORAGE
  private var comics: [ComicResult] = []

  // THE SERVICE API
  private let apiClient: MarvelAPIProtocol

  private(set) var title = "All Characters List..."

  init(dependencies: AppDependencies) {
    self.apiClient = dependencies.marvelApiClient
  }

  func add(comics: [ComicResult]) {
    return self.comics.append(contentsOf: comics)
  }

  func getComic(at index: Int) -> ComicResult {
    return comics[index]
  }

  func comicsCount() -> Int {
    return comics.count
  }

  // MARK: - API FUNCTIONS
  func getComicsList(completion: @escaping ( () -> Void) ) {
    apiClient.getComicsList { ( comics: [ComicResult])  in
      self.comics = comics
      completion()
    }
  }

  func getNextComicsList(completion: @escaping () -> Void) {
    apiClient.getNextComicsList { ( comics: [ComicResult])  in
      // Update dataSOurce array
      self.comics += comics
      completion()
    }
  }
}
