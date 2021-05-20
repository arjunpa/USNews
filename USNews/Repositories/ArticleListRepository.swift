//
//  ArticleListRepository.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleListRepositoryInterface {
    func fetchArticles(completion: @escaping (Result<ArticleListResponse, Error>) -> Void,
                       queue: OperationQueue)
}

final class ArticleListRepository {
    
    private let apiService: APIServiceInterface
    
    init(apiService: APIServiceInterface, queue: OperationQueue) {
        self.apiService = apiService
    }
    
    func fetchArticles(completion: @escaping (Result<ArticleListResponse, Error>) -> Void,
                       queue: OperationQueue) {
        
        let request = Request(url: APIEndPoint.newsListAPI,
                                   method: .get,
                                   parameters: nil,
                                   headers: nil,
                                   encoding: RequestURLEncoding())
        
        self.apiService.request(for: request) { (result: Result<APIHTTPDecodableResponse<ArticleListResponse>, Error>) in
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
}