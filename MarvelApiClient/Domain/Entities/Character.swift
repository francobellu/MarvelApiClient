//
//  Character.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//// MARK: - Result
struct Character: Equatable {
  static func == (lhs: Character, rhs: Character) -> Bool {
    lhs.id == rhs.id
  }

  let id: Int?
  let name: String?
  let description: String?
//  let modified: String?
  let resourceURI: String?
//  let urls: [URLElement]?
  let thumbnail: Thumbnail?
  let comics: Int
  let stories: Int
  let events: Int
  let series: Int

  init(id: Int?,
       name: String?,
       description: String?,
       resourceURI: String?,
       thumbnail: Thumbnail?,
       comics: Int,
       stories: Int,
       events: Int,
       series: Int){
    self.id = id
    self.name = name
    self.description = description
    self.resourceURI = resourceURI
    self.thumbnail = thumbnail
    self.comics = comics
    self.stories = stories
    self.events = events
    self.series = series
  }

  init(name: String, imageUrl: URL?) {
    self.name = name
    thumbnail = Thumbnail(from: imageUrl )
    id = nil
    description = nil
    resourceURI = nil
    comics = 0
    stories = 0
    events = 0
    series = 0
  }
}
