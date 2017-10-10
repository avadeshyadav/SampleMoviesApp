//
//  TMDBMovieListCell.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit
import SDWebImage

class TMDBMovieListCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfiguratinos()
    }

    func configureCell(with model: TMDBMovieListCellViewModel) {
    
        movieTitleLabel.text = model.title
        popularityLabel.text = model.popularity
        posterImageView.sd_setImage(with: model.imageUrl, completed: nil)
    }
    
    //MARK: Private Methods
    func doInitialConfiguratinos() {
        
    }
}
