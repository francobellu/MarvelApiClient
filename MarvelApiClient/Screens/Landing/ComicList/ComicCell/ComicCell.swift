//
//  ComicCell.swift
//  MarvelApiClient
//
//  Created by BELLU Franco on 14/05/2020.
//  Copyright © 2020 BELLU Franco. All rights reserved.
//

import UIKit

//@IBDesignable
class ComicCell: UITableViewCell {

  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var title: UILabel!

  static let id = R.reuseIdentifier.comicCellId
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  func config(with comic: ComicResult) {
    title.text = comic.title
    title.numberOfLines = 0
    title.lineBreakMode = .byWordWrapping
    guard let thumbnail = comic.thumbnail else { return }
    let placeholderImage = UIImage(named: "amour-0.jpg")
    imgView.af.setImage(withURL: thumbnail.url, placeholderImage: placeholderImage, filter: nil)
    imgView.contentMode = .scaleToFill
  }
}
