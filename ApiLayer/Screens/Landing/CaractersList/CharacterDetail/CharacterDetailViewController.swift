//
//  CharacterDetailViewController.swift
//  
//
//  Created by BELLU Franco on 02/11/2018.
//

import UIKit
import AlamofireImage

class CharacterDetailViewController: UIViewController, StoryboardInstantiable {
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var thumbnailView: UIImageView!
  @IBOutlet weak var details: UILabel!
  @IBOutlet weak var idLabel: UILabel!

  var viewModel: CharacterDetailViewModel!

  func set(character: CharacterResult) {
    self.name.text = character.name
    guard let thumbnail = character.thumbnail else { return  }
    self.thumbnailView.af.setImage(withURL: thumbnail.url)
    self.details.text = character.resultDescription
    self.idLabel.text = String(describing: character.id)
  }

  override func viewDidLoad() {
    guard let character = viewModel.character else { return }
    set(character: character)
    super.viewDidLoad()
  }
}
