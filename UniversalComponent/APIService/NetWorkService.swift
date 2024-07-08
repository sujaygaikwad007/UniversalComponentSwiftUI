import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

class NetworkService {
    
    let baseUrl = "" //Put your base url here
    
    func request<T: Codable>(urlString: String, method: HTTPMethod, requestBody: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: baseUrl + urlString) else {
            print("Invalid URL")
            return
        }
        
        print("NetworkService URL----\(url)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestBody = requestBody {
            urlRequest.httpBody = requestBody
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Error making request: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                print("Response received---- \(decodedResponse)")
                completion(.success(decodedResponse))
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
