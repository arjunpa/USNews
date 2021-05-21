//
//  ArticleDetailRepository.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleDetailRepositoryInterface {
    func retrieveComments(articleID: String,
                          queue: OperationQueue,
                          completion: @escaping (Result<ArticleComments, Error>) -> Void)
    func retrieveLikes(articleID: String,
                       queue: OperationQueue,
                       completion: @escaping (Result<ArticleLikes, Error>) -> Void)
    func retrieveLikesAndComments(articleID: String,
                                  queue: OperationQueue,
                                  completion: @escaping (Result<ArticleLikes, Error>, Result<ArticleComments, Error>) -> Void)
}

final class ArticleDetailRepository: ArticleDetailRepositoryInterface {
    
    let apiService: APIServiceInterface
    
    private let groupQueue = DispatchQueue(label: "com.detail.repository")
    
    init(apiService: APIServiceInterface) {
        self.apiService = apiService
    }
    
    func retrieveComments(articleID: String,
                          queue: OperationQueue,
                          completion: @escaping (Result<ArticleComments, Error>) -> Void) {
        
        let commentsURL: URLFormable
        
        do {
            commentsURL = try APIEndPoint.articleComments.appendingPathComponent(component: articleID)
        } catch {
            completion(.failure(error))
            return
        }
        
        let request = Request(url: commentsURL,
                              method: .get,
                              parameters: nil,
                              headers: nil,
                              encoding: RequestURLEncoding())
        
        self.apiService.request(for: request) { (result: Result<APIHTTPDecodableResponse<ArticleComments>, Error>) in
            switch result {
            case .success(let response):
                
                queue.addOperation {
                    completion(.success(response.decoded))
                }
            case .failure(let error):
                queue.addOperation {
                    completion(.failure(error))
                }
            }
        }

    }
    
    func retrieveLikes(articleID: String,
                       queue: OperationQueue,
                       completion: @escaping (Result<ArticleLikes, Error>) -> Void) {
        
        let likesURL: URLFormable
        
        do {
            likesURL = try APIEndPoint.articleLikes.appendingPathComponent(component: articleID)
        } catch {
            completion(.failure(error))
            return
        }
        
        let request = Request(url: likesURL,
                              method: .get,
                              parameters: nil,
                              headers: nil,
                              encoding: RequestURLEncoding())
        
        self.apiService.request(for: request) { (result: Result<APIHTTPDecodableResponse<ArticleLikes>, Error>) in
            switch result {
            case .success(let response):
                
                queue.addOperation {
                    completion(.success(response.decoded))
                }
            case .failure(let error):
                queue.addOperation {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func retrieveLikesAndComments(articleID: String, queue: OperationQueue, completion: @escaping (Result<ArticleLikes, Error>, Result<ArticleComments, Error>) -> Void) {
        
        var likesResult: Result<ArticleLikes, Error>?
        var commentsResult: Result<ArticleComments, Error>?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        dispatchGroup.notify(queue: groupQueue) {
            
            queue.addOperation {
                guard let likesResult = likesResult, let commentsResult = commentsResult else {
                    return
                }
                completion(likesResult, commentsResult)
            }
        }
        
        self.retrieveComments(articleID: articleID,
                                               queue: .main)
        { result in
            commentsResult = result
            
            dispatchGroup.leave()
        }
        
        self.retrieveLikes(articleID: articleID,
                                            queue: .main)
        { result in
            likesResult = result
            
            dispatchGroup.leave()
        }
    }
}
