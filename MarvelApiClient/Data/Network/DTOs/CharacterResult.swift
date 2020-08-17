//
//  CharacterResult.swift
//  MarvelApiClient
//
//  Created by franco bellu on 07/08/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import Foundation

// MARK: - Result
public struct CharacterResult: Codable, Equatable {
  public static func == (lhs: CharacterResult, rhs: CharacterResult) -> Bool {
    lhs.id == rhs.id
  }

  let id: Int?
  let name: String?
  let description: String?
  let modified: String?
  let resourceURI: String?
  let urls: [URLElement]?
  let thumbnail: Thumbnail?
  let comics: Comics?
  let stories: Stories?
  let events: Comics?
  let series: Comics?

  init(name: String, imageUrl: URL?) {
    self.name = name
    self.thumbnail = Thumbnail(from: imageUrl )
    id = nil

    description = nil
    modified = nil
    resourceURI = nil
    urls = nil
    comics = nil
    stories = nil
    events = nil
    series = nil
  }
}

extension CharacterResult {
  func toDomain() -> Character {
    return Character(id: id,
                     name: name,
                     description: description,
                     resourceURI: resourceURI,
                     thumbnail: thumbnail,
                     comics: comics?.items?.count ?? 0,
                     stories: stories?.items?.count ?? 0,
                     events: events?.items?.count ?? 0,
                     series: series?.items?.count ?? 0)
  }
}
