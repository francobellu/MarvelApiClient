//
//  ComicVc.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class AvengersViewController: UIViewController, StoryboardInstantiable {

  let apiClient = MarvelAPIClient(httpClient: HttpClient())
  weak var coordinatorDelegate: AvengersListTransitionsProtocol! //swiftlint:disable:this implicitly_unwrapped_optional
  var comics: [ComicResult]! // swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    super.viewDidLoad()
    apiClient.getComicsAvengers { ( comics: [ComicResult])  in
      // Update dataSOurce comics
      self.comics += comics
      print(comics)
    }
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }
}
