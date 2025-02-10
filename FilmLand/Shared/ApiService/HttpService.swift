//
//  Untitled.swift
//  FilmLand
//
//  Created by Jorge Azurduy on 2/9/25.
//
import Foundation

enum HttpMethod: String {
    case get = "get"
    case post = "post"
    case put = "put"
}

enum WebError: Error {
    case requestFailed
    case serverError(statusCode: Int)
    case badURL
    case unknown(Error)
    case noData
    case noConnection
    
    var description: String {
        switch self {
            case .requestFailed:
                return "Failed request try again."
            case .serverError(statusCode: let statusCode):
                return "Server response give a unexpected status code: \(statusCode)"
            case .badURL:
                return "Wrong url verify the if the path exists."
            case .unknown(_):
                return "Unknowk error. Report to Administrator."
            case .noData:
                return "The service respond with the request with no data."
            case .noConnection:
                return "The internet connection is not working or is too low."
        }
    }
}

class HttpService {
    
    var baseUrl: String = ""
    var serviceVersion: String = ""
    var accessToken: String = ""
    var language: String = ""
    
    init(baseUrl: String = Path.baseURL,
         serviceVersion: String = "/" + SharedValues.serviceVersion,
         accessToken: String = SharedValues.accessToken,
         language: String = SharedValues.language) {
        
        self.baseUrl = baseUrl
        self.serviceVersion = serviceVersion
        self.accessToken = accessToken
        self.language = language
    }
    
    
    func sendRequest(text: String, path: String, parameters: String, page: String, method: HttpMethod = .get) async throws -> ResultMedia? {
        
        if Reachability.isConnectedToNetwork() {
            let url = URL(string: baseUrl + serviceVersion + path)!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            
            let queryItems: [URLQueryItem] = [
              URLQueryItem(name: "query", value: text),
              URLQueryItem(name: "include_adult", value: "false"),
              URLQueryItem(name: "language", value: language),
              URLQueryItem(name: "page", value: page),
            ]
            
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = method.rawValue
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": SharedValues.applicationJson,
                "Authorization": "Bearer \(SharedValues.accessToken)"
            ]
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                    throw WebError.serverError(statusCode: response.statusCode)
                }
                
                let resultData = try JSONDecoder().decode(ResultMedia.self, from: data)
                return resultData
            } catch {
                throw WebError.requestFailed
            }
        } else {
            throw WebError.noConnection
        }
        
        return nil
    }
    
    private func printJSON(data: Data, path: String, method: HttpMethod) {
        print()
        print("\(method.rawValue.uppercased()): \(path)")
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("JSON malformed data.")
        }
    }
}
