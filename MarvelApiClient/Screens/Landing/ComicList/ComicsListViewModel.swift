//
//  ComicsListViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class ComicsListViewModel {

  private weak var coordinatorDelegate: ComicsListCoordinatorDelegate! //swiftlint:disable:this implicitly_unwrapped_optional

  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelAPIProtocol{
    dependencies.marvelApiClient
  }

  private var comics: [ComicResult] = []

  private(set) var title = "Marvel Comics"

  init(dependencies: AppDependencies, coordinatorDelegate: ComicsListCoordinatorDelegate) {
    self.dependencies = dependencies
    self.coordinatorDelegate = coordinatorDelegate
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
    apiClient.getComicsList { ( comics: [ComicResult])  in
      // Update dataSOurce array
      self.comics += comics
      completion()
    }
  }
}

extension ComicsListViewModel{
  func didGoBack(){
    coordinatorDelegate.didGoBack()
  }

  func didSelect(comic: ComicResult){
    coordinatorDelegate.didSelect(comic: comic)
  }
}
