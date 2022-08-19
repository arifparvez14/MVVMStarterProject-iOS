//
//  MovieTableViewCell.swift
//  Movie List
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(title: String?, overview: String?, posterUrl: URL?) {
        titleLabel.text = title
        overViewLabel.text = overview
        posterImageView.image = UIImage(named: defaultThumbnailImageName)

        if let imageUrl = posterUrl {
            posterImageView.loadImage(fromUrl: imageUrl)
        }
    }
}
