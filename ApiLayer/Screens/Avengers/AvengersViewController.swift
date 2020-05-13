//
//  ComicVc.swift
//  ApiLayer
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

class AvengersViewController: UIViewController, StoryboardInstantiable {

  let apiClient = MarvelAPIClient(httpClient: HttpClient())
  weak var coordinatorDelegate: AvengersListTransitionsProtocol! //swiftlint:disable:this implicitly_unwrapped_optional
  var comics: [ComicResult]!

  override func viewDidLoad() {
    super.viewDidLoad()
    apiClient.getComicsAvengers { ( comics: [ComicResult])  in
      // Update dataSOurce comics
      self.comics += comics
      print(comics)
      // Reload Data
      //DispatchQueue.main.sync { self.tableView.reloadData() }
    }
  }

  @IBAction func flow1Action(_ sender: Any) {
    coordinatorDelegate.btn1Selected()
  }

  @IBAction func flow2Action(_ sender: Any) {
    coordinatorDelegate.btn2Selected()
  }

  @IBAction func flow3Action(_ sender: Any) {
    coordinatorDelegate.btn3Selected()
  }

  func didGoBack() {
    coordinatorDelegate.didGoBack()
  }
}
