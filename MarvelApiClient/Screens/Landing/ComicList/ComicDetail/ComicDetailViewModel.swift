//
//  ComicDetailViewModel.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class ComicDetailViewModel: AppDependencyInjectable {
  var dependencies: AppDependencies!
  var comic: ComicResult!
  var comicId: String!

  init(dependencies: AppDependencies, comic: ComicResult) {
    self.comic = comic
  }

  init(dependencies: AppDependencies, comicId: String) {
    self.dependencies = dependencies
    self.comicId = comicId
  }

  func getName() -> String {
    return "Comics Detail: \(String(describing: comic.title))"
  }

  func getDescription() -> String {
    guard let description = comic.textObjects?.first?.text else { return ""}
    return "\(String(description))"
  }

  func getIssueNumber() -> String {
    guard let issueNumber = comic.issueNumber else { return ""}
    return "Issue Number: \(String(issueNumber))"
  }

  func getPageCount() -> String {
    guard let pageCount = comic.pageCount else { return ""}
    return "Page Number: \(String(pageCount))"
  }

  func getSeries() -> String {
    guard let series = comic.series,
    let seriesName = series.name else { return ""}
    return "Series: \(seriesName)"
  }
}
