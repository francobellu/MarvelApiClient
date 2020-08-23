import Foundation

struct ErrorResponse: Decodable {
  let code: String?
  let message: String?
}

struct MarvelResponse<Response: Decodable>: Decodable {
  let code: Int?
  let status: String?
  let copyright: String?
  let attributionText: String?
  let attributionHTML: String?
  let data: DataContainer<Response>?
  let etag: String?
}

struct DataContainer<Results: Decodable>: Decodable {
  public let offset: Int
  public let limit: Int
  public let total: Int
  public let count: Int
  public let results: Results
}

// Comics.swift

// MARK: - Comics
struct Comics: Codable {
  let available: Int?
  let returned: Int?
  let collectionURI: String?
  let items: [ComicsItem]?
}

// ComicsItem.swift

// MARK: - ComicsItem
struct ComicsItem: Codable {
  let resourceURI: String?
  let name: String?
}

// Stories.swift

// MARK: - Stories
struct Stories: Codable {
  let available: Int?
  let returned: Int?
  let collectionURI: String?
  let items: [StoriesItem]?
}

// StoriesItem.swift

// MARK: - StoriesItem
struct StoriesItem: Codable {
  let resourceURI: String?
  let name: String?
  let type: String?
}

// Thumbnail.swift

// MARK: - Thumbnail
struct Thumbnail: Codable {
  let url: URL
  enum ImageKeys: String, CodingKey {
    case path = "path"
    case thumbnailExtension = "extension"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ImageKeys.self)

    let thumbnailExtension = try container.decode(String.self, forKey: .thumbnailExtension)
    do {
      let path = try container.decode(String.self, forKey: .path)
      let urlStr = "\(path).\(thumbnailExtension)"
      guard let url = URL(string: urlStr) else {
        print("Errror")
        throw MarvelError.decoding
      }
      self.url = url
    } catch {
     throw MarvelError.decoding
    }
  }

  public init(from imageUrl: URL?) {
    guard let defaultImageUrl = Bundle.main.url(forResource: "amour-1", withExtension: "jpg") else {
      fatalError()
    }

    if let url = imageUrl {
      self.url = url
    } else {
      self.url = defaultImageUrl
    }
  }
}

// URLElement.swift

// MARK: - URLElement
struct URLElement: Codable {
  let type: String?
  let url: String?
}

// MARK: - Result
struct ComicResult: Codable {
  let id: Int?
  let digitalID: String?
  let title: String?
  let issueNumber: Int?
  let variantDescription: String?
  let resultDescription: String?
  let modified: String?
  let isbn: String?
  let upc: String?
  let diamondCode: String?
  let ean: String?
  let issn: String?
  let format: String?
  let pageCount: Int?
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
}

// MARK: - Characters
struct Characters: Codable {
  let available: Int?
  let returned: Int?
  let collectionURI: String?
  let items: [CharactersItem]?
}

// MARK: - CharactersItem
struct CharactersItem: Codable {
  let resourceURI: String?
  let name: String?
  let role: String?

}

// MARK: - Series
struct Series: Codable {
  let resourceURI: String?
  let name: String?

}

// MARK: - DateElement
struct DateElement: Codable {
  let type: String?
  let date: String?

}

// MARK: - Events
struct Events: Codable {
  let available: Int?
  let returned: Int?
  let collectionURI: String?
  let items: [Series]?

  enum CodingKeys: String, CodingKey {
    case available
    case returned
    case collectionURI
    case items
  }
}

// MARK: - Price
struct Price: Codable {
  let type: String?
  let price: Double?

  enum CodingKeys: String, CodingKey {
    case type
    case price
  }
}

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
