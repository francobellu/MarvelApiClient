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

  @IBOutlet var imgView: UIImageView!
  @IBOutlet var title: UILabel!

  static let id = R.reuseIdentifier.characterCellId
//  override func awakeFromNib() {
//    super.awakeFromNib()
//    // Initialization code
//  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    title = UILabel()
    imgView = UIImageView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func config(with characterCellViewModel: CharacterCellViewModel) {
    title.text = characterCellViewModel.title
    let placeholderImage = UIImage(named: "amour-0.jpg")
    imgView.af.setImage(withURL: characterCellViewModel.imgViewUrl, placeholderImage: placeholderImage, filter: nil)
    imgView.contentMode = .scaleToFill
  }
}
