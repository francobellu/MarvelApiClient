//
//  ComicsListPresenter.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class ComicsListPresenter {

  private weak var coordinatorDelegate: ComicsListCoordinatorDelegate! //swiftlint:disable:this implicitly_unwrapped_optional

  private var dependencies: AppDependenciesProtocol! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelApiProtocol{
    dependencies.marvelApiClient
  }

  private var comics: [ComicResult] = []

  private(set) var title = "Marvel Comics"

  init(dependencies: AppDependenciesProtocol, coordinatorDelegate: ComicsListCoordinatorDelegate) {
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

extension ComicsListPresenter{
  func didGoBack(){
    coordinatorDelegate.didGoBack()
  }

  func didSelect(comic: ComicResult){
    coordinatorDelegate.didSelect(comic: comic)
  }
}
