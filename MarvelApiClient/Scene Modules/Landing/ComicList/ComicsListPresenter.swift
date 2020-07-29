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
  func getNextComicsList(completion: @escaping () -> Void) {
    let request = GetComics(restDependencies: dependencies.restDependencies)
    // todo: use interactor
    request.execute { ( result: Result<GetComics.Response, Error>)  in

      switch result {
      case .success(let comics):
//        self.isLoading.value = false
//        self.buildPresentationModel(from: characters)
        self.comics += comics
      case .failure(let error):
        print(error)
//        todo: handle error
//        self.isError.value = error
        // Hanlde Errors
      }
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
