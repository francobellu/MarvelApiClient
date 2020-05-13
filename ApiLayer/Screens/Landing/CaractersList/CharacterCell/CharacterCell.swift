//
//  CharacterCell.swift
//  ApiLayer
//
//  Created by BELLU Franco on 29/10/2018.
//  Copyright © 2018 BELLU Franco. All rights reserved.
//

import UIKit

//@IBDesignable
class CharacterCell: UITableViewCell {

  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var title: UILabel!

  static let id = R.reuseIdentifier.vc1CellId
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  func config(with characther: CharacterResult) {
    title.text = characther.name
    guard let thumbnail = characther.thumbnail else { return }
    let placeholderImage = UIImage(named: "amour-0.jpg")
    //print ("Cell.imageView: url: \(imageUrl.absoluteString)")
    imgView.af.setImage(withURL: thumbnail.url, placeholderImage: placeholderImage, filter: nil)
    imgView.contentMode = .scaleToFill
  }
}
