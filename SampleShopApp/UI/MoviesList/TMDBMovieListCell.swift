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
    @IBOutlet weak var containerView: UIView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfiguratinos()
    }

    func configureCell(with model: TMDBMovieListCellViewModel) {
    
        movieTitleLabel.text = model.title
        popularityLabel.text = model.popularity
        
        posterImageView.__sd_setImage(with:model.imageUrl, placeholderImage: UIImage(named: "placeHolder"), completed: nil)
    }
    
    //MARK: Private Methods
    func doInitialConfiguratinos() {
        //        posterImageView.addShadowWithColor(UIColor.darkGray, offset: CGSize.zero)
        containerView.makeCornerRadiusWithValue(4.0, borderColor: UIColor.lightGray)
        posterImageView.makeCornerRadiusWithValue(2.0)
    }
}
