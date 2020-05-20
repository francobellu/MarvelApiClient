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
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var comicsLabel: UILabel!
  @IBOutlet weak var seriesLabel: UILabel!
  @IBOutlet weak var storiesLabel: UILabel!

  var presenter: CharacterDetailPresenter! // swiftlint:disable:this implicitly_unwrapped_optional

  override func viewDidLoad() {
    configureView()
    super.viewDidLoad()
  }

  func configureView() {
    title = presenter.getName()

    guard let thumbnail = presenter.getThumbnailUrl() else { return  }
    thumbnailView.af.setImage(withURL: thumbnail)

    descriptionLabel.text = presenter.getDescription()
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping

    comicsLabel.text = presenter.getComicsCount()
    seriesLabel.text = presenter.getSeriesCount()
    storiesLabel.text = presenter.getStoriesCount()

  }
}
