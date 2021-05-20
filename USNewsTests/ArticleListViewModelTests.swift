//
//  ArticleListViewModelTests.swift
//  USNewsTests
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import XCTest

@testable import USNews

final class ArticleListViewModelTests: XCTestCase {

    private enum TestResponse {
        static let validResponse = """
            {
              "status": "ok",
              "totalResults": 38,
              "articles": [
                {
                  "source": {
                    "id": null,
                    "name": "Eonline.com"
                  },
                  "author": "Kaitlin Reilly",
                  "title": "Mariska Hargitay Hospitalized After Suffering Multiple Leg Injuries - E! NEWS",
                  "description": "Mariska Hargitay, star of Law and Order: SVU posted an Instagram pic in front of the hospital after sustaining multiple leg injuries. Scroll to read more about her recent ordeal.",
                  "url": "https://www.eonline.com/news/1271478/mariska-hargitay-hospitalized-after-suffering-multiple-leg-injuries",
                  "urlToImage": "https://akns-images.eonline.com/eol_images/Entire_Site/2021419/rs_1200x1200-210519160538-1200-mariska-hargitay-red-carpet.jpg?fit=around%7C1080:1080&output-quality=90&crop=1080:1080;center,top",
                  "publishedAt": "2021-05-20T02:37:16Z",
                  "content": "Mariska Hargitayis still standing after sustaining multiple leg injuries. "
                },
                {
                  "source": {
                    "id": null,
                    "name": "SciTechDaily"
                  },
                  "author": null,
                  "title": "Research on Bizarre Rodent Genetics Solves a Mystery – And Then Things Got Even Stranger - SciTechDaily",
                  "description": "Open up Scott Roy’s Twitter bio and you’ll see a simple but revealing sentence: “The more I learn the more I’m confused.” Now the rest of the scientific world can share in his confusion. The San Francisco State University associate professor of Biology’s most…",
                  "url": "https://scitechdaily.com/research-on-bizarre-rodent-genetics-solves-a-mystery-and-then-things-got-even-stranger/",
                  "urlToImage": "https://scitechdaily.com/images/Taiwan-Vole.jpg",
                  "publishedAt": "2021-05-20T01:56:53Z",
                  "content": "A Taiwan vole, closely related to the creeping vole described in the study."
                }
              ]
            }
        """
    }
    
    private var viewUpdateDelegate: ViewUpdater? = ViewUpdater()
    
    final class ViewUpdater: ArticleListUpdateViewDelegate {
        
        var onUpdateView: (() -> Void)?
        
        var onError: ((Error) -> Void)?
        
        func updateView() {
            onUpdateView?()
        }
        
        func updateOnError(error: Error) {
            self.onError?(error)
        }
    }
    
    final class MockAPIService: APIServiceInterface {
        
        enum ResultSimulation {
            case data(String, HTTPURLResponse)
            case error(Error)
        }
        
        var simulationMode: ResultSimulation = .data("", HTTPURLResponse(url: URL(string: "http://fake.com")!,
                                                                         statusCode: 200,
                                                                         httpVersion: nil,
                                                                         headerFields: nil)!)
        
        func request<T>(for request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>, Error>) -> Void) where T : Decodable {
            switch self.simulationMode {
            case .data(let jsonResponse, let httpResponse):
                let data = jsonResponse.data(using: .utf8) ?? Data()
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                            
                    completion(.success(APIHTTPDecodableResponse<T>(data: data,
                                                                    decoded: decoded,
                                                                    httpResponse: httpResponse)))
                } catch {
                    completion(.failure(error))
                }
        
            case .error(let error):
                completion(.failure(error))
            }
        }
        
        func request(for request: Requestable, completion: @escaping (Result<APIHTTPDataResponse, Error>) -> Void) {
            switch self.simulationMode {
                case .data(let jsonResponse, let httpResponse):
                    let data = jsonResponse.data(using: .utf8) ?? Data()
                    completion(.success(APIHTTPDataResponse(data: data, httpResponse: httpResponse)))
            
                case .error(let error):
                    completion(.failure(error))
            }

        }
    }
    
    private let mockAPIService = MockAPIService()
    
    func testWithValidArticleResponse() {
        let viewModel = ArticleListViewModel(repository: ArticleListRepository(apiService: mockAPIService ,
                                                                               queue: .main))
        
        viewModel.viewDelegate = viewUpdateDelegate
        
        mockAPIService.simulationMode = .data(TestResponse.validResponse, HTTPURLResponse(url: try! APIEndPoint.newsListAPI.asURL(),
                                                                                          statusCode: 200,
                                                                                          httpVersion: "1.0",
                                                                                          headerFields: nil)!)
        
        let expectation = self.expectation(description: "testing.valid.response")

        self.viewUpdateDelegate?.onUpdateView = {
            expectation.fulfill()
        }
        
        viewModel.fetchArticles()
        
        waitForExpectations(timeout: 3.0, handler: nil)
        
        XCTAssertTrue(viewModel.numberOfArticles == 2)
        XCTAssertTrue(viewModel.articleAtIndex(index: 0)?.title == "Mariska Hargitay Hospitalized After Suffering Multiple Leg Injuries - E! NEWS")
        XCTAssertTrue(viewModel.articleAtIndex(index: 0)?.author == "Kaitlin Reilly")
        XCTAssertTrue(viewModel.articleAtIndex(index: 0)?.imageURL?.absoluteString == "https://akns-images.eonline.com/eol_images/Entire_Site/2021419/rs_1200x1200-210519160538-1200-mariska-hargitay-red-carpet.jpg?fit=around%7C1080:1080&output-quality=90&crop=1080:1080;center,top")
        XCTAssertTrue(viewModel.articleAtIndex(index: 0)?.description == "Mariska Hargitay, star of Law and Order: SVU posted an Instagram pic in front of the hospital after sustaining multiple leg injuries. Scroll to read more about her recent ordeal.")
        XCTAssertTrue(viewModel.articleAtIndex(index: 0)?.articleURL?.absoluteString == "https://www.eonline.com/news/1271478/mariska-hargitay-hospitalized-after-suffering-multiple-leg-injuries")
        
        XCTAssertTrue(viewModel.articleAtIndex(index: 1)?.author == nil)
        XCTAssertTrue(viewModel.articleAtIndex(index: 1)?.title == "Research on Bizarre Rodent Genetics Solves a Mystery – And Then Things Got Even Stranger - SciTechDaily")
        XCTAssertTrue(viewModel.articleAtIndex(index: 1)?.imageURL?.absoluteString == "https://scitechdaily.com/images/Taiwan-Vole.jpg")
        XCTAssertTrue(viewModel.articleAtIndex(index: 1)?.description == "Open up Scott Roy’s Twitter bio and you’ll see a simple but revealing sentence: “The more I learn the more I’m confused.” Now the rest of the scientific world can share in his confusion. The San Francisco State University associate professor of Biology’s most…")
        XCTAssertTrue(viewModel.articleAtIndex(index: 1)?.articleURL?.absoluteString == "https://scitechdaily.com/research-on-bizarre-rodent-genetics-solves-a-mystery-and-then-things-got-even-stranger/")
        
    }
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
