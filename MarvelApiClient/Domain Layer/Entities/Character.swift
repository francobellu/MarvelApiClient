//
//  Character.swift
//  MarvelApiClient
//
//  Created by franco bellu on 06/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

//// MARK: - Result
struct Character: Equatable, Codable {
  static func == (lhs: Character, rhs: Character) -> Bool {
    lhs.id == rhs.id
  }

  let id: Int?
  let name: String?
  let description: String?
  let resourceURI: String?
  let imageUrl: URL?
  let comics: Int
  let stories: Int
  let events: Int
  let series: Int

  init(id: Int?,
       name: String?,
       description: String? = nil,
       resourceURI: String? = nil,
       imageUrl: URL?,
       comics: Int = 0,
       stories: Int = 0,
       events: Int = 0,
       series: Int = 0) {
    self.id = id
    self.name = name
    self.description = description
    self.resourceURI = resourceURI
    self.imageUrl = imageUrl
    self.comics = comics
    self.stories = stories
    self.events = events
    self.series = series
  }

  enum CharacterCodingKey: String, CodingKey {
      case id, name, description, resourceURI, imageUrl, comics, stories, events, series
  }

  init(name: String, imageUrl: URL?, id: Int? = nil) {
    self.name = name
    self.id = id
    description = nil
    resourceURI = nil
    self.imageUrl = imageUrl
    comics = 0
    stories = 0
    events = 0
    series = 0
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CharacterCodingKey.self)
    name = try container.decode(String.self, forKey: .name)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    description = try container.decodeIfPresent(String.self, forKey: .description)
    resourceURI = try container.decodeIfPresent(String.self, forKey: .resourceURI)
    imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)

    comics = try container.decode(Int.self, forKey: .comics)
    stories = try container.decode(Int.self, forKey: .stories)
    events = try container.decode(Int.self, forKey: .events)
    series = try container.decode(Int.self, forKey: .series)
  }
}
