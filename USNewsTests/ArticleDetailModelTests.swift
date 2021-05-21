//
//  ArticleDetailModelTests.swift
//  USNewsTests
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import XCTest

@testable import USNews

class ArticleDetailModelTests: XCTestCase {

    private enum Stubs {
        static let validArticleDict: [String: Any] = [
            "title": "Research on Bizarre Rodent Genetics Solves a Mystery",
            "author": "Daniel Radcliffe",
            "description": "Open up Scott Roy’s Twitter bio and you’ll see a simple but revealing sentence.",
            "url": "https://scitechdaily.com/research-on-bizarre-rodent-genetics-solves-a-mystery-and-then-things-got-even-stranger",
            "urlToImage": "https://scitechdaily.com/images/Taiwan-Vole.jpg",
            "publishedAt": "2021-05-20T01:56:53Z",
            "content": "A Taiwan vole, closely related to the creeping vole described in the study."
        ]
        
        static let validArticleWithMissingFields: [String: Any] = [
            "title": "Research on Bizarre Rodent Genetics Solves a Mystery",
            "url": "https://scitechdaily.com/research-on-bizarre-rodent-genetics-solves-a-mystery-and-then-things-got-even-stranger",
            "publishedAt": "2021-05-20T01:56:53Z",
            "content": "A Taiwan vole, closely related to the creeping vole described in the study."
        ]
        
        static let validLikeResponse = """
            {
                "likes": 23
            }
        """
        
        static let validCommentsResponse = """
            {
                "comments": 16
            }
        """
    }
    
    private var viewUpdateDelegate: ViewUpdater? = ViewUpdater()
    
    private final class ViewUpdater: ArticleDetailViewUpdateDelegate {
        
        var onUpdateViewAtIndex: ((Int) -> Void)?
        
        var onUpdateView: (() -> Void)?
        
        func updateView() {
            onUpdateView?()
        }
        
        func updateView(at index: Int) {
            onUpdateViewAtIndex?(index)
        }
    }
    
    private final class MockAPIService: APIServiceInterface {
        
        enum ResultSimulation {
            case data(String, HTTPURLResponse)
            case error(Error)
        }
        
        var likeResult: ResultSimulation = .data("", HTTPURLResponse(url: URL(string: "http://fake.com")!,
                                                                         statusCode: 200,
                                                                         httpVersion: nil,
                                                                          headerFields: nil)!)
        var commentsResult: ResultSimulation = .data("", HTTPURLResponse(url: URL(string: "http://fake.com")!,
                                                                         statusCode: 200,
                                                                         httpVersion: nil,
                                                                         headerFields: nil)!)
        
        func request<T: Decodable>(for request: Requestable,
                        completion: @escaping (Result<APIHTTPDecodableResponse<T>, Error>) -> Void) {
            let urlRequest: URLRequest
            do {
               urlRequest = try request.asURLRequest()
            } catch {
                completion(.failure(error))
                return
            }
            
            if urlRequest.url?.absoluteString.contains(APIEndPoint.articleLikes.rawValue) == true {
                completion(self.resultDecodable(simulationMode: self.likeResult, type: T.self))
            } else {
                completion(self.resultDecodable(simulationMode: self.commentsResult, type: T.self))
            }
        }
        
        private func resultDecodable<T: Decodable>(simulationMode: ResultSimulation, type: T.Type) -> Result<APIHTTPDecodableResponse<T>, Error> {
            switch simulationMode {
                case .data(let jsonResponse, let httpResponse):
                    let data = jsonResponse.data(using: .utf8) ?? Data()
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                                
                        return .success(APIHTTPDecodableResponse<T>(data: data,
                                                                    decoded: decoded,
                                                                    httpResponse: httpResponse))
                    } catch {
                        return .failure(error)
                    }
            
                case .error(let error):
                    return .failure(error)
                }
        }
        
        private func result(simulationMode: ResultSimulation) -> Result<APIHTTPDataResponse, Error> {
            switch simulationMode {
                case .data(let jsonResponse, let httpResponse):
                    let data = jsonResponse.data(using: .utf8) ?? Data()
                    return .success(APIHTTPDataResponse(data: data, httpResponse: httpResponse))
            
                case .error(let error):
                    return .failure(error)
                }
        }
        
        func request(for request: Requestable, completion: @escaping (Result<APIHTTPDataResponse, Error>) -> Void) {
            let urlRequest: URLRequest
            do {
               urlRequest = try request.asURLRequest()
            } catch {
                completion(.failure(error))
                return
            }
            if urlRequest.url?.absoluteString.contains(APIEndPoint.articleLikes.rawValue) == true {
                completion(result(simulationMode: self.likeResult))
            } else {
                completion(result(simulationMode: self.commentsResult))
            }
        }
    }
    
    private let mockAPIService = MockAPIService()
    
    func testAllPossibleSections() {
        guard let article = try? JSONDecoder().decode(Article.self, with: Stubs.validArticleDict) else {
            XCTFail("The json is expected to pass decoding.")
            return
        }
        
        let detailViewModel = ArticleDetailViewModel(article: article,
                                                     detailRepository: ArticleDetailRepository(apiService: mockAPIService))
        
        XCTAssertTrue(detailViewModel.numberOfRows == 4)
        
        XCTAssertTrue({
            let imageSection = detailViewModel.row(at: 0)
            switch imageSection {
            case .some(.image(let detailSection)):
                return detailSection.url?.absoluteString == "https://scitechdaily.com/images/Taiwan-Vole.jpg"
            default:
                return false
            }
        } ())
        
        XCTAssertTrue({
            let titleSection = detailViewModel.row(at: 1)
            switch titleSection {
            case .some(.title(let titleSection)):
                return titleSection.title == "Research on Bizarre Rodent Genetics Solves a Mystery" && titleSection.author == "Daniel Radcliffe"
            default:
                return false
            }
        } ())
        
        // Since we didn't call for likes and comments retrievel, the initial states of likes and comments must be nil.
        XCTAssertTrue({
            let likesAndComments = detailViewModel.row(at: 2)
            switch likesAndComments {
            case .some(.likesAndComments(let likesAndComments)):
                return likesAndComments.commentsDescription == nil && likesAndComments.likesDescription == nil
            default:
                return false
            }
        } ())
        
        XCTAssertTrue({
            let descSection = detailViewModel.row(at: 3)
            switch descSection {
            case .some(.description(let articleDescription)):
                return articleDescription.description == "Open up Scott Roy’s Twitter bio and you’ll see a simple but revealing sentence."
            default:
                return false
            }
        } ())
    }
    
    func testWithMissingSections() {
        guard let article = try? JSONDecoder().decode(Article.self, with: Stubs.validArticleWithMissingFields) else {
            XCTFail("The json is expected to pass decoding.")
            return
        }
        
        let detailViewModel = ArticleDetailViewModel(article: article,
                                                     detailRepository: ArticleDetailRepository(apiService: mockAPIService))
        XCTAssertTrue(detailViewModel.numberOfRows == 3)
        
        XCTAssertTrue({
            let imageSection = detailViewModel.row(at: 0)
            switch imageSection {
            case .some(.image(let detailSection)):
                return detailSection.url == nil
            default:
                return false
            }
        } ())
        
        XCTAssertTrue({
            let titleSection = detailViewModel.row(at: 1)
            switch titleSection {
            case .some(.title(let titleSection)):
                return titleSection.title == "Research on Bizarre Rodent Genetics Solves a Mystery" && titleSection.author == nil
            default:
                return false
            }
        } ())
        
        XCTAssertTrue({
            let likesAndComments = detailViewModel.row(at: 2)
            switch likesAndComments {
            case .some(.likesAndComments(let likesAndComments)):
                return likesAndComments.commentsDescription == nil && likesAndComments.likesDescription == nil
            default:
                return false
            }
        } ())
    }
    
    func testRetrievingLikesAndComments() {
        guard let article = try? JSONDecoder().decode(Article.self, with: Stubs.validArticleWithMissingFields) else {
            XCTFail("The json is expected to pass decoding.")
            return
        }
        
        mockAPIService.likeResult = .data(Stubs.validLikeResponse, HTTPURLResponse(url: URL(string: "http://fake.com")!,
                                                                                   statusCode: 200,
                                                                                   httpVersion: nil,
                                                                                   headerFields: nil)!)
        mockAPIService.commentsResult = .data(Stubs.validCommentsResponse, HTTPURLResponse(url: URL(string: "http://fake.com")!,
                                                                                       statusCode: 200,
                                                                                       httpVersion: nil,
                                                                                       headerFields: nil)!)
        let expectation = self.expectation(description: "testing.articledetail.valid.response")
        
        let detailViewModel = ArticleDetailViewModel(article: article,
                                                     detailRepository: ArticleDetailRepository(apiService: mockAPIService))
        detailViewModel.viewDelegate = viewUpdateDelegate
        
        viewUpdateDelegate?.onUpdateViewAtIndex = { index in
            expectation.fulfill()
            
            switch detailViewModel.row(at: index) {
            case .some(.likesAndComments(let likesAndComments)):
                XCTAssertTrue(likesAndComments.likesDescription == "23")
                XCTAssertTrue(likesAndComments.commentsDescription == "16")
            default:
                XCTFail("The index returned for the view update doesn't match that of the likes and comments section.")
            }
        }
        
        detailViewModel.retrieveLikesAndComments()
        
        wait(for: [expectation], timeout: 5.0)
    }
}
