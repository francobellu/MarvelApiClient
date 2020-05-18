//
//  ComicDetailViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class ComicDetailViewModel{
  var comic: ComicResult! // swiftlint:disable:this implicitly_unwrapped_optional

  private var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional

  private var apiClient: MarvelAPIProtocol{
    dependencies.marvelApiClient
  }

  init(dependencies: AppDependencies, comic: ComicResult) {
    self.comic = comic
  }

  /// Initializer used for deep linking
  init(dependencies: AppDependencies, comicId: String) {
    self.dependencies = dependencies
  }

  // MARK: - API FUNCTIONS
  func getComic(with comicId: Int, completion: @escaping () -> Void) {
    apiClient.getComic(with: comicId) { comic in
      self.comic = comic
      print("FB: comic: \(comic)")
      completion()
    }
  }

  func getName() -> String {
    guard let description = comic.title else { return "Comic Detail"}
    return description
  }

  func getDescription() -> String {
    guard let description = comic.textObjects?.first?.text else { return "No Description Available"}
    return description
  }

  func getSeries() -> String {
    guard let series = comic.series,
    let seriesName = series.name else { return ""}
    return "Series: \(seriesName)"
  }
}
