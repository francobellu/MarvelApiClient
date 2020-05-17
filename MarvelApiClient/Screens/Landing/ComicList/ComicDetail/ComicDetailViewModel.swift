//
//  ComicDetailViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class ComicDetailViewModel: AppDependencyInjectable {
  var dependencies: AppDependencies! // swiftlint:disable:this implicitly_unwrapped_optional
  var comic: ComicResult! // swiftlint:disable:this implicitly_unwrapped_optional
  var comicId: String! // swiftlint:disable:this implicitly_unwrapped_optional

  init(dependencies: AppDependencies, comic: ComicResult) {
    self.comic = comic
  }

  init(dependencies: AppDependencies, comicId: String) {
    self.dependencies = dependencies
    self.comicId = comicId
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
