//
//  TMDBMovieDescriptionCell.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 11/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import UIKit

class TMDBMovieDescriptionCell: UITableViewCell {

    @IBOutlet weak var infoHeaderLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with model: TMDBHeaderDescriptionCellViewModel) {
        
        infoHeaderLabel.text = model.headerText
        infoLabel.text = model.descriptionText
    }
}
