//
//  GetComic.swift
//  MarvelApiClient
//
//  Created by franco bellu on 20/04/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.welcomeTask(with: url) { welcome, response, error in
  //     if let welcome = welcome {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Welcome
  struct GetComic: Codable {
      let code: String?
      let status: String?
      let copyright: String?
      let attributionText: String?
      let attributionHTML: String?
      let data: DataClass?
      let etag: String?

      enum CodingKeys: String, CodingKey {
          case code
          case status
          case copyright
          case attributionText
          case attributionHTML
          case data
          case etag
      }
  }

  // DataClass.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let dataClass = try? newJSONDecoder().decode(DataClass.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.dataClassTask(with: url) { dataClass, response, error in
  //     if let dataClass = dataClass {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - DataClass
  struct DataClass: Codable {
      let offset: String?
      let limit: String?
      let total: String?
      let count: String?
      let results: [Result]?

      enum CodingKeys: String, CodingKey {
          case offset
          case limit
          case total
          case count
          case results
      }
  }

  // Result.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let result = try? newJSONDecoder().decode(Result.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.resultTask(with: url) { result, response, error in
  //     if let result = result {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Result
  struct Result: Codable {
      let id: String?
      let digitalID: String?
      let title: String?
      let issueNumber: String?
      let variantDescription: String?
      let resultDescription: String?
      let modified: String?
      let isbn: String?
      let upc: String?
      let diamondCode: String?
      let ean: String?
      let issn: String?
      let format: String?
      let pageCount: String?
      let textObjects: [TextObject]?
      let resourceURI: String?
      let urls: [URLElement]?
      let series: Series?
      let variants: [Series]?
      let collections: [Series]?
      let collectedIssues: [Series]?
      let dates: [DateElement]?
      let prices: [Price]?
      let thumbnail: Thumbnail?
      let images: [Thumbnail]?
      let creators: Characters?
      let characters: Characters?
      let stories: Stories?
      let events: Events?

      enum CodingKeys: String, CodingKey {
          case id
          case digitalID
          case title
          case issueNumber
          case variantDescription
          case resultDescription
          case modified
          case isbn
          case upc
          case diamondCode
          case ean
          case issn
          case format
          case pageCount
          case textObjects
          case resourceURI
          case urls
          case series
          case variants
          case collections
          case collectedIssues
          case dates
          case prices
          case thumbnail
          case images
          case creators
          case characters
          case stories
          case events
      }
  }

  // Characters.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let characters = try? newJSONDecoder().decode(Characters.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.charactersTask(with: url) { characters, response, error in
  //     if let characters = characters {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Characters
  struct Characters: Codable {
      let available: String?
      let returned: String?
      let collectionURI: String?
      let items: [CharactersItem]?

      enum CodingKeys: String, CodingKey {
          case available
          case returned
          case collectionURI
          case items
      }
  }

  // CharactersItem.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let charactersItem = try? newJSONDecoder().decode(CharactersItem.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.charactersItemTask(with: url) { charactersItem, response, error in
  //     if let charactersItem = charactersItem {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - CharactersItem
  struct CharactersItem: Codable {
      let resourceURI: String?
      let name: String?
      let role: String?

      enum CodingKeys: String, CodingKey {
          case resourceURI
          case name
          case role
      }
  }

  // Series.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let series = try? newJSONDecoder().decode(Series.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.seriesTask(with: url) { series, response, error in
  //     if let series = series {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Series
  struct Series: Codable {
      let resourceURI: String?
      let name: String?

      enum CodingKeys: String, CodingKey {
          case resourceURI
          case name
      }
  }

  // DateElement.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let dateElement = try? newJSONDecoder().decode(DateElement.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.dateElementTask(with: url) { dateElement, response, error in
  //     if let dateElement = dateElement {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - DateElement
  struct DateElement: Codable {
      let type: String?
      let date: String?

      enum CodingKeys: String, CodingKey {
          case type
          case date
      }
  }

  // Events.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let events = try? newJSONDecoder().decode(Events.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.eventsTask(with: url) { events, response, error in
  //     if let events = events {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Events
  struct Events: Codable {
      let available: String?
      let returned: String?
      let collectionURI: String?
      let items: [Series]?

      enum CodingKeys: String, CodingKey {
          case available
          case returned
          case collectionURI
          case items
      }
  }

  // Thumbnail.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let thumbnail = try? newJSONDecoder().decode(Thumbnail.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.thumbnailTask(with: url) { thumbnail, response, error in
  //     if let thumbnail = thumbnail {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Thumbnail
  struct Thumbnail: Codable {
      let path: String?
      let thumbnailExtension: String?

      enum CodingKeys: String, CodingKey {
          case path
          case thumbnailExtension
      }
  }

  // Price.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let price = try? newJSONDecoder().decode(Price.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.priceTask(with: url) { price, response, error in
  //     if let price = price {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Price
  struct Price: Codable {
      let type: String?
      let price: String?

      enum CodingKeys: String, CodingKey {
          case type
          case price
      }
  }

  // Stories.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let stories = try? newJSONDecoder().decode(Stories.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.storiesTask(with: url) { stories, response, error in
  //     if let stories = stories {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - Stories
  struct Stories: Codable {
      let available: String?
      let returned: String?
      let collectionURI: String?
      let items: [StoriesItem]?

      enum CodingKeys: String, CodingKey {
          case available
          case returned
          case collectionURI
          case items
      }
  }

  // StoriesItem.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let storiesItem = try? newJSONDecoder().decode(StoriesItem.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.storiesItemTask(with: url) { storiesItem, response, error in
  //     if let storiesItem = storiesItem {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - StoriesItem
  struct StoriesItem: Codable {
      let resourceURI: String?
      let name: String?
      let type: String?

      enum CodingKeys: String, CodingKey {
          case resourceURI
          case name
          case type
      }
  }

  // TextObject.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let textObject = try? newJSONDecoder().decode(TextObject.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.textObjectTask(with: url) { textObject, response, error in
  //     if let textObject = textObject {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - TextObject
  struct TextObject: Codable {
      let type: String?
      let language: String?
      let text: String?

      enum CodingKeys: String, CodingKey {
          case type
          case language
          case text
      }
  }

  // URLElement.swift

  // This file was generated from JSON Schema using quicktype, do not modify it directly.
  // To parse the JSON, add this file to your project and do:
  //
  //   let uRLElement = try? newJSONDecoder().decode(URLElement.self, from: jsonData)
  //
  // To read values from URLs:
  //
  //   let task = URLSession.shared.uRLElementTask(with: url) { uRLElement, response, error in
  //     if let uRLElement = uRLElement {
  //       ...
  //     }
  //   }
  //   task.resume()

  import Foundation

  // MARK: - URLElement
  struct URLElement: Codable {
      let type: String?
      let url: String?

      enum CodingKeys: String, CodingKey {
          case type
          case url
      }
  }

  // JSONSchemaSupport.swift

  import Foundation

  // MARK: - Helper functions for creating encoders and decoders

  func newJSONDecoder() -> JSONDecoder {
      let decoder = JSONDecoder()
      if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
          decoder.dateDecodingStrategy = .iso8601
      }
      return decoder
  }

  func newJSONEncoder() -> JSONEncoder {
      let encoder = JSONEncoder()
      if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
          encoder.dateEncodingStrategy = .iso8601
      }
      return encoder
  }

  // MARK: - URLSession response handlers

  extension URLSession {
      fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
          return self.dataTask(with: url) { data, response, error in
              guard let data = data, error == nil else {
                  completionHandler(nil, response, error)
                  return
              }
              completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
          }
      }

      func welcomeTask(with url: URL, completionHandler: @escaping (Welcome?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
          return self.codableTask(with: url, completionHandler: completionHandler)
      }
  }
