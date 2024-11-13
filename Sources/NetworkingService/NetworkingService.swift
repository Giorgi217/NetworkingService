// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class Networking: NetworkServiceProtocol {
    
    public init() { }

    public func fetchData<T: Decodable>(urlString: String, completion: @escaping @Sendable (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


public enum NetworkError: Error {
    case invalidURL
    case noData
}

public protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(urlString: String, completion: @escaping @Sendable (Result<T, Error>) -> Void)
}

