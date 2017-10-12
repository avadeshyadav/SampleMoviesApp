//
//  MovieDetailsModelTests.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 12/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import XCTest
@testable import SampleShopApp

class MovieDetailsModelTests: XCTestCase {
    
    let model = TMDBMovieDetailsViewModel()
    let dataProvider = MovieDetailsDataProvider()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetCellTypesMethodWithAllOptionalCellsPresent() {
       
        let movieDetailsItem = TMDBMovieDetailsItem(with: dataProvider.getValidJSONWithAllKeys())
        let cellTypes = model.getCellTypes(from: movieDetailsItem)
        
        let allCellTypes: Array<MovieDetailsCellTypes> = [.imageAndDescription, .languages, .generes, .releaseDate, .endDummyCell]
        
        for cellType in allCellTypes {
        
            XCTAssertTrue(cellTypes.contains(cellType), "TMDBMovieDetailsViewModel getCellType method unable to add \(cellType)")
        }
    }
    
    func testGetCellTypesMethodWithAllOptionalCellsMissing() {
        
        let movieDetailsItem = TMDBMovieDetailsItem(with: dataProvider.getValidJSONWithMissingOptionalKeys())
        var cellTypes = model.getCellTypes(from: movieDetailsItem)
        let mandatoryCellTypes: Array<MovieDetailsCellTypes> = [.imageAndDescription, .endDummyCell]
        
        for cellType in mandatoryCellTypes {
            
            if let index = cellTypes.index(of: cellType) {
                cellTypes.remove(at: index)
            }
        }
        
        for cellType in cellTypes {
            XCTAssertTrue(false, "TMDBMovieDetailsViewModel getCellType method must not add cell type: \(cellType) if the value is not present in movie details item")
        }
    }
    
    func testImageCellViewModel() {

        let rawDetails = dataProvider.getValidJSONWithAllKeys()
        model.movieDetails = TMDBMovieDetailsItem(with: rawDetails)
        let cellViewModel = model.getImageAndNameCellModel()
        
        let title = rawDetails["title"] as? String
        XCTAssertTrue(cellViewModel.title == title, "Title Value is wrongly formed in TMDBMovieDetailsViewModel")
        
        let overVeiw = rawDetails["overview"] as? String
        XCTAssertTrue(cellViewModel.overVeiw == overVeiw, "overVeiw Value is wrongly formed in TMDBMovieDetailsViewModel")

        var imageUrl: URL?
        if let posterPath = rawDetails["poster_path"] as? String {
            let urlString = kBaseImageURLPath + posterPath
            imageUrl = URL(string: urlString)
        }
        XCTAssertTrue(cellViewModel.imageUrl == imageUrl, "imageUrl Value is wrongly formed in TMDBMovieDetailsViewModel")

        var popularity: String?
        if let value =  rawDetails["popularity"] as? Double {
            popularity = "Popularity: " + String(format: "%.2f", value)
        }
        
        XCTAssertTrue(cellViewModel.popularity == popularity, "popularity Value is wrongly formed in TMDBMovieDetailsViewModel")

        var duration: String?
        if let value =  rawDetails["runtime"] as? Int {
            duration = "Duration: \(value / 60)Hrs : \(value % 60)Mins"
        }
        XCTAssertTrue(cellViewModel.duration == duration, "duration Value is wrongly formed in TMDBMovieDetailsViewModel")
    }
}


class MovieDetailsDataProvider {

    func getValidJSONWithAllKeys() -> Dictionary<String, Any> {
        
        let dictionary: Dictionary<String, Any> = [
            "overview": "Aliens land in South Africa and, with their ship totally disabled,  have no way home. Years later, after living in a slum and wearing out their welcome the 'Non-Humans' are being moved to a new tent city overseen by Multi-National United (MNU).",
            "id": 17654,
            "title": "District 9",
            "poster_path": "/axFmCRNQsW6Bto8XuJKo08MPPV5.jpg",
            "spoken_languages": [
                [
                    "iso_639_1":  "af",
                    "name": "Afrikaans"
                ],
                [
                    "iso_639_1": "zu",
                    "name": "isiZulu"
                ],
                [
                    "iso_639_1": "en",
                    "name": "English"
                ]],
            "genres": [
                [
                    "id": 878,
                    "name": "Science Fiction"], [
                        "id": 877,
                        "name": "Technology"]],
            "runtime": 112,
            "release_date": "2009-08-05",
            "popularity": 11.589835
        ]
        
        return dictionary
    }
    
    func getValidJSONWithMissingOptionalKeys() -> Dictionary<String, Any> {
        
        let dictionary: Dictionary<String, Any> = [
            "overview": "Aliens land in South Africa and, with their ship totally disabled,  have no way home. Years later, after living in a slum and wearing out their welcome the 'Non-Humans' are being moved to a new tent city overseen by Multi-National United (MNU).",
            "id": 17654,
            "title": "District 9",
            "poster_path": "/axFmCRNQsW6Bto8XuJKo08MPPV5.jpg",
            "runtime": 112,
            "popularity": 11.589835
        ]
        
        return dictionary
    }
}

