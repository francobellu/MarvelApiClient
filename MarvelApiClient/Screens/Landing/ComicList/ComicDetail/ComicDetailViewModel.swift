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
  private(set) var title = "Comic Detail"

  // THE STORAGE
  var comic: ComicResult?
  var comicId: String?

  init(dependencies: AppDependencies, comic: ComicResult) {
    self.dependencies = dependencies
    self.comic = comic
  }

  init(dependencies: AppDependencies, comicId: String) {
    self.dependencies = dependencies
    self.comicId = comicId
  }

  // MARK: - API FUNCTIONS

//  private func getCharacter(for id: Int)  {
//    dependencies.marvelApiClient.getCharactersList { ( character: ComicCharacter)  in
//      self.character = character
//      completion()
//    }
//  }
}
