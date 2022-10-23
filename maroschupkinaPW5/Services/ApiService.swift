//
//  ApiService.swift
//  maroschupkinaPW5
//
//  Created by Marina Roshchupkina on 23.10.2022.
//

import Foundation

public enum ApiResult {
    case failure(error: Error)
    case success(articles: [NewsSource.Article])
}

public struct NewsSource: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
    
    public struct Article: Codable {
        let source: Source
        let author: String?
        let title: String
        let articleDescription: String?
        let url: String
        let urlToImage: String?
        let publishedAt: String
        let content: String?

        enum CodingKeys: String, CodingKey {
            case source, author, title
            case articleDescription = "description"
            case url, urlToImage, publishedAt, content
        }
        
        struct Source: Codable {
            let id: String?
            let name: String
        }
    }
    
    
}

class ApiService {
    static var shared = ApiService()
    static var key = "fec4719546604dbea9ab925b6c1eab57"
    public var articles: [NewsSource.Article] = []
    
    private func getURL() -> URL? {
        URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(ApiService.key)")
    }
    
    func getTopStories(_ completion: @escaping (ApiResult?)->()) {
        guard let url = getURL() else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completion(ApiResult.failure(error: error))
                return
            }
            if let data = data {
                var articles = try? JSONDecoder().decode(NewsSource.self, from: data).articles
                /* do {
                    let decoder = JSONDecoder()
                    let articles = try decoder.decode(NewsSource.self, from: data)
                    print(articles as Any)
                } catch DecodingError.dataCorrupted(let context) {
                    print(context)
                } catch DecodingError.keyNotFound(let key, let context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.valueNotFound(let value, let context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch DecodingError.typeMismatch(let type, let context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                } */
                completion(ApiResult.success(articles: articles ?? []))
            }
        }.resume()
    }
    
}
