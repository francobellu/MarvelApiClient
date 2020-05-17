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
    title = viewModel.getName()

    guard let thumbnail = character.thumbnail else { return  }
    thumbnailView.af.setImage(withURL: thumbnail.url)
    let width = UIScreen.main.bounds.size.width
    let size = CGSize(width: width, height: width * 0.80)
    thumbnailView.sizeThatFits(size)

    comicsLabel.text = viewModel.getComicsCount()
    seriesLabel.text = viewModel.getSeriesCount()
    storiesLabel.text = viewModel.getStoriesCount()
    idLabel.text = "Id: \(id)"
  }
}
