//
//  CharacterDetailViewController.swift
//  
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit
import AlamofireImage

class CharacterDetailViewController: UIViewController, StoryboardInstantiable {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var thumbnailView: UIImageView!

  @IBOutlet weak var comicsLabel: UILabel!
  @IBOutlet weak var seriesLabel: UILabel!
  @IBOutlet weak var storiesLabel: UILabel!


  var viewModel: CharacterDetailViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    configureView()
    title = viewModel.title
    super.viewDidLoad()
  }

  func configureView() {
    guard let character = viewModel.character,
          let id = character.id  else { return }
    self.name.text = character.name
    guard let thumbnail = character.thumbnail else { return  }
    self.thumbnailView.af.setImage(withURL: thumbnail.url)
    let pictureFrame = UIScreen.main.bounds.size
    self.thumbnailView.sizeThatFits(pictureFrame)
    self.comicsLabel.text = viewModel.getComicsCount()
    self.seriesLabel.text = viewModel.getSeriesCount()
    self.storiesLabel.text = viewModel.getStoriesCount()
    self.idLabel.text = "Id: \(id)"
  }
}
