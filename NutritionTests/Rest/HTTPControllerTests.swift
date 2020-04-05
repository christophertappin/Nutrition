//
//  HTTPControllerTests.swift
//  NutritionTests
//
//  Created by ChrisTappin on 05/04/2020.
//  Copyright © 2020 ChrisTappin. All rights reserved.
//

import XCTest
@testable import Nutrition

class HTTPControllerTests: XCTestCase {

    class URLSessionMock: HTTPURLSession {

        // Set these variables in the test
        var data: Data?
        var response: URLResponse?
        var error: Error?

        func urlDataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            completionHandler(data, response, error)
        }

    }

    var responseData: Data?

    override func setUp() {
        responseData = """
        {
            "meta": {
                "code": 200
            },
            "response": {
                "carbs": 3.04,
                "fiber": 0.0,
                "title": "Ricotta cheese",
                "pcstext": "Whole cheese",
                "potassium": 0.105,
                "sodium": 0.084,
                "calories": 174,
                "fat": 12.98,
                "sugar": 0.27,
                "gramsperserving": 20.0,
                "cholesterol": 0.051,
                "protein": 11.26,
                "unsaturatedfat": 4.012,
                "saturatedfat": 8.295
            }
        }
        """.data(using: .utf8)
    }

    func testSuccess() {
        let sessionMock = URLSessionMock()
        sessionMock.data = responseData

        sessionMock.response = HTTPURLResponse(url: URL(string: "http://test.url")!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)

        let httpController = HTTPController(session: sessionMock)

        let expectedResponse = NutritionResponse(title: "Ricotta cheese",
                                                 pcstext: "Whole cheese",
                                                 gramsperserving: 20.0,
                                                 calories: 174,
                                                 carbs: 3.04,
                                                 protein: 11.26,
                                                 fat: 12.98,
                                                 unsaturatedfat: 4.012,
                                                 saturatedfat: 8.295,
                                                 fiber: 0.0,
                                                 potassium: 0.105,
                                                 sodium: 0.084,
                                                 sugar: 0.27,
                                                 cholesterol: 0.051)

        var processedResult: Result<NutritionRequest.ResponseType, HTTPError>?

        let nutritionRequest = NutritionRequest()

        httpController.process(nutritionRequest) { result in
            processedResult = result
        }

        XCTAssertEqual(expectedResponse.title, try? processedResult?.get().title)
        // TODO: test the rest to make sure this really is the correct result
    }

}
