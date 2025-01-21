import Foundation

enum HTTPMethod:String{
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}
enum NetworkError: Error,LocalizedError{
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case custom(String)

    var errorDescription: String?{
        switch self{
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response from server"
        case .noData: return "No data received"
        case .decodingError: return "Failed to decode data"
        case .custom(let message): return message

        }
    }
}
class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}

    func request<T:Codable>(
        urlString : String,
        method: HTTPMethod = .get,
        header:[String:String]? = nil,
        body:Data?=nil,
        responseType:T.Type,
        completion: @escaping(Result<T,NetworkError>) -> Void

    ){
        guard let url = URL(string: urlString) else{
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        request.httpBody = body

        URLSession.shared.dataTask(with: request){ data,response,error in

            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else{
                completion(.failure(.noData))
                return
            }

            do {
                let decodeData = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodeData))
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString ?? "")")
                }
                completion(.failure(.decodingError))
            }


        }.resume()
    }

}
