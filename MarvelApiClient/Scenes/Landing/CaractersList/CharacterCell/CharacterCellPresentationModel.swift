//
//  CharacterCellPresentationModel.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation


class CharacterCellPresentationModel {
  var title: String
  var imgViewUrl: URL
  init(character: CharacterResult) {
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
