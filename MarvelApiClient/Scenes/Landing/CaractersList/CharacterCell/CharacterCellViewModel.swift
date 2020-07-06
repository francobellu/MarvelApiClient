//
//  CharacterCellViewModel.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/07/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation


class CharacterCellViewModel {
  var title: String
  var imgViewUrl: URL
  init(character: CharacterResult) {
    title = character.name ?? ""
    let defaultImageUrl = Bundle.main.url(forResource: "amour-1", withExtension: "jpg")!

    imgViewUrl = character.thumbnail?.url != nil ? character.thumbnail!.url : defaultImageUrl
//
//    if let thumbnailUrl = character.thumbnail?.url {
//      imgViewUrl = thumbnailUrl
//    } else {
//      imgViewUrl = defaultImageUrl
//    }
  }
}
