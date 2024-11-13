// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class NewsViewModel: NetworkService {
    
   public init() { }
    
    public func fetchData<T: Decodable>(urlString: String, completion: @escaping @Sendable (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            
            if let decodedResponse = try? decoder.decode(T.self, from: data) {
                completion(.success(decodedResponse))
            } else {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}

public enum NetworkError: Error {
    case invalidURL
    case decodingError
    case networkError(Error)
    case unknown
}

public protocol NetworkService {
    func fetchData<T: Decodable>(urlString: String, completion: @escaping @Sendable (Result<T, Error>) -> Void)
}
