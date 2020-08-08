//
//  CharacterCellPresentationModel.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

class CharacterCellPresentationModel: Equatable {
  static func == (lhs: CharacterCellPresentationModel, rhs: CharacterCellPresentationModel) -> Bool {
    lhs.title == rhs.title
  }

  var title: String
  var imgViewUrl: URL
  init(character: Character) {
    title = character.name ?? ""
    guard let defaultImageUrl = Bundle.main.url(forResource: "amour-1", withExtension: "jpg") else{
      fatalError()
    }

    if let thumbnailUrl = character.thumbnail?.url {
      imgViewUrl = thumbnailUrl
    } else {
      imgViewUrl = defaultImageUrl
    }
  }
}
