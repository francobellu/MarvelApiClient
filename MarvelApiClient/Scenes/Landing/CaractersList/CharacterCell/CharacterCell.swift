//
//  CharacterCell.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

//@IBDesignable
class CharacterCell: UITableViewCell {

  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var title: UILabel!

  static let id = R.reuseIdentifier.characterCellId
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func config(with characterViewModel: CharacterCellViewModel) {
    title.text = characterViewModel.title
    let placeholderImage = UIImage(named: "amour-0.jpg")
    imgView.af.setImage(withURL: characterViewModel.imgViewUrl, placeholderImage: placeholderImage, filter: nil)
    imgView.contentMode = .scaleToFill
  }
}
