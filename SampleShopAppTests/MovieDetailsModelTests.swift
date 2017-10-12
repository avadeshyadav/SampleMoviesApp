//
//  MovieDetailsModelTests.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 12/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import XCTest

class MovieDetailsModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMoviesModel() {
        
        let dictionary: Dictionary<String, Any> = [
            "overview": "Aliens land in South Africa and, with their ship totally disabled,  have no way home. Years later, after living in a slum and wearing out their welcome the 'Non-Humans' are being moved to a new tent city overseen by Multi-National United (MNU).",
            "id": 17654,
            "title": "District 9",
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
    }
}

