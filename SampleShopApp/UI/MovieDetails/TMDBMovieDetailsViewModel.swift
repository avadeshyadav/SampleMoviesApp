//
//  TMDBMovieDetailsViewModel.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 10/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation

struct TMDBImageCellViewModel {
    
    var title: String?
    var imageUrl: URL?
    var popularity: String?
    var duration: String?
    var overVeiw: String?
    
    init(with movieItem: TMDBMovieDetailsItem) {
        
        title = movieItem.title
        overVeiw = movieItem.overView
        
        if let posterPath = movieItem.posterPath {
            let urlString = kBaseImageURLPath + posterPath
            imageUrl = URL(string: urlString)
        }
        
        if let value =  movieItem.popularity {
            popularity = "Popularity: " + String(format: "%.2f", value)
        }
        
        if let value =  movieItem.runTime {
            duration = "Duration: \(value / 60)Hrs : \(value % 60)Mins"
        }
    }
}

struct TMDBHeaderDescriptionCellViewModel {
    var headerText: String?
    var descriptionText: String?
}

enum MovieDetailsCellTypes: Int {
    case imageAndDescription, languages, generes, releaseDate, endDummyCell
}

class TMDBMovieDetailsViewModel {
    
    var currentMovieId: String?
    var movieDetails: TMDBMovieDetailsItem?
    var cellTypes = Array<MovieDetailsCellTypes>()

    func getImageAndNameCellModel() -> TMDBImageCellViewModel {
        return TMDBImageCellViewModel(with: movieDetails!)
    }
    
    func getModelFor(cellType type: MovieDetailsCellTypes) -> TMDBHeaderDescriptionCellViewModel {
        
        if type == .generes {
            
            let stringGeneres = movieDetails?.generes?.joined(separator: ", ")
            return TMDBHeaderDescriptionCellViewModel(headerText: "Generes", descriptionText: stringGeneres)
        }
        else  if type == .languages {
            let stringLanguages = movieDetails?.languages?.joined(separator: ", ")
            return TMDBHeaderDescriptionCellViewModel(headerText: "Languages", descriptionText: stringLanguages)
        }
        else {
            return TMDBHeaderDescriptionCellViewModel(headerText: "Release Date", descriptionText: movieDetails?.releaseDate)
        }
    }

    
    func getMovieDetails(with completionBlock: @escaping CompletionBlock) -> URLSessionDataTask? {
        
        let movieService = TMDBMoviesService(with: .movieDetails)
        
        return movieService.getMovieDetails(with: currentMovieId!, onError: { (error) in
            
            completionBlock(error as AnyObject?)
            
        }) { [weak self] (data) in
            
            if let details = data as? TMDBMovieDetailsItem {
                self?.movieDetails = details
                self?.prepareCellTypes(from: details)
            }
            
            completionBlock(data as AnyObject)
        }
    }
    
    //MARK: Private Methods
    func prepareCellTypes(from details: TMDBMovieDetailsItem)  {
        
        cellTypes.removeAll()
        cellTypes.append(.imageAndDescription)
        
        if let languages = details.languages, languages.count > 0 {
            cellTypes.append(.languages)
        }
        
        if let genres = details.generes, genres.count > 0 {
            cellTypes.append(.generes)
        }
        
        if let _ = details.releaseDate {
            cellTypes.append(.releaseDate)
        }
        
        cellTypes.append(.endDummyCell)
    }

    
}
