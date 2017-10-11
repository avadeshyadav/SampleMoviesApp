//
//  TMDBMovieImageCell.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 11/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBMovieImageCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfiguratinos()
    }
    
    func configureCell(with model: TMDBImageCellViewModel) {
        
        movieTitleLabel.text = model.title
        popularityLabel.text = model.popularity
        durationLabel.text = model.duration
        overViewLabel.text = model.overVeiw
        
        posterImageView.__sd_setImage(with:model.imageUrl, placeholderImage: UIImage(named: "placeholderImage"), completed: nil)
    }
    
    //MARK: Private Methods
    func doInitialConfiguratinos() {
        posterImageView.makeCornerRadiusWithValue(3.0)
    }
}
