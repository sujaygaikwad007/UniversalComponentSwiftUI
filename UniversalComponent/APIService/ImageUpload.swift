//
//  ImageUpload.swift
//  UniversalComponent
//
//  Created by Sujay Gaikwad on 20/01/25.
//

import Foundation




import Foundation
import Combine

class UserCreatedAddFoodImageViewModel: ObservableObject {
    
  //  @Published private var createFoodAddFoodImageModel: CreateFoodAddFoodImageModel?
    
    let urlString = APIEndPoint.shared.userCreateFoodAddImage()
    let headers: [String: String] = [
        "Authorization": "Bearer \(APIEndPoint.token)"
    ]
    
    
    func createUserFood(foodDetails: [String: Any], measurementBasics: String, image: Data, imageName: String) {
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            return
        }
        
        var multipart = MultipartRequest()
        
        // Add "foodDetails" as JSON string
        if let jsonData = try? JSONSerialization.data(withJSONObject: foodDetails, options: []) {
            let jsonString = String(data: jsonData, encoding: .utf8) ?? "{}"
            multipart.add(key: "foodDetails", value: jsonString)
        }
        
        // Add "measurementBasics"
        multipart.add(key: "measurementBasics", value: measurementBasics)
        
        // Add "image" as file
        multipart.add(
            key: "image",
            fileName: imageName,
            fileMimeType: "image/png", // Adjust MIME type as per the actual image type
            fileData: image
        )
        
        let requestBody = multipart.httpBody
        if let requestBodyString = String(data: requestBody, encoding: .utf8) {
            print("Request Body:\n\(requestBodyString)")
        } else {
            print("Error: Unable to convert request body to string.")
        }
        
        // Create the HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.setValue(headers["Authorization"], forHTTPHeaderField: "Authorization")
        request.httpBody = multipart.httpBody
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Invalid Response")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                print("Error: \(errorMessage)")
                return
            }
            
            let successMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Success"
            print("Create user food-------> \(successMessage)")
            
        }.resume()
    }
}


public struct MultipartRequest {
    public let boundary: String
    private let separator: String = "\r\n"
    private var data: Data
    
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }
    
    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)".data(using: .utf8) ?? Data())
    }
    
    private mutating func appendSeparator() {
        data.append(separator.data(using: .utf8) ?? Data())
    }
    
    private func disposition(_ key: String) -> String {
        return "Content-Disposition: form-data; name=\"\(key)\""
    }
    
    public mutating func add(key: String, value: String) {
        appendBoundarySeparator()
        data.append((disposition(key) + separator).data(using: .utf8) ?? Data())
        appendSeparator()
        data.append((value + separator).data(using: .utf8) ?? Data())
    }
    
    public mutating func add(key: String, fileName: String, fileMimeType: String, fileData: Data) {
        appendBoundarySeparator()
        data.append((disposition(key) + "; filename=\"\(fileName)\"" + separator).data(using: .utf8) ?? Data())
        data.append(("Content-Type: \(fileMimeType)" + separator + separator).data(using: .utf8) ?? Data())
        data.append(fileData)
        appendSeparator()
    }
    
    public var httpContentTypeHeadeValue: String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    public var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--".data(using: .utf8) ?? Data())
        return bodyData
    }
}





//Multipart image with image compression


import Foundation
import Combine
import UIKit

class UserCreatedAddFoodImageViewModel: ObservableObject {
   // @Published private var createFoodAddFoodImageModel: CreateFoodAddFoodImageModel?
    
    let urlString = APIEndPoint.shared.userCreateFoodAddImage()
    let headers: [String: String] = [
        "Authorization": "Bearer \(APIEndPoint.token)"
    ]
    
    func createUserFood(shortFoodDescription: String, brandName: String, image: Data, imageName: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL")
            completion(false)
            return
        }

        var multipart = MultipartRequest()
        
        // Check if the image size exceeds 1 MB and compress if necessary
        var compressedImageData = image
        if image.count > 1 * 1024 * 1024 { // 1 MB in bytes
            if let compressedImage = compressImage(image: UIImage(data: image)!) {
                compressedImageData = compressedImage
            }
        }
        
        let imageSizeInBytes = compressedImageData.count
        let imageSizeInMB = Double(imageSizeInBytes) / (1024.0 * 1024.0)
        print("Image Data Size: \(String(format: "%.2f", imageSizeInMB)) MB")

        // Add "shortFoodDescription"
        multipart.add(key: "shortFoodDescription", value: shortFoodDescription)

        // Add "brandName"
        multipart.add(key: "brandName", value: brandName)

        // Determine MIME type based on image extension
        let mimeType = mimeTypeForImage(imageName)
        print("mimeType------>", mimeType)

        // Add "image" as file
        multipart.add(
            key: "image",
            fileName: imageName,
            fileMimeType: mimeType, // Dynamically set MIME type
            fileData: compressedImageData
        )
        
        // Log the raw request body
        let requestBody = multipart.httpBody
        print("Request Body (raw data):", requestBody)

        // Create the HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
        request.setValue(headers["Authorization"], forHTTPHeaderField: "Authorization")
        request.httpBody = requestBody

        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Invalid Response")
                completion(false)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                print("Error: \(errorMessage)")
                completion(false)
                return
            }
            
            let successMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Success"
            print("Create user food-------> \(successMessage)")
            
            if let data = data {
                do {
                    let decodedModel = try JSONDecoder().decode(CreateFoodAddFoodImageModel.self, from: data)
                    DispatchQueue.main.async {
                        self.createFoodAddFoodImageModel = decodedModel
                        UserDefaults.standard.set(decodedModel.data?.foodID, forKey: "userCreateFoodId")
                        print("FoodId from APICall----->", decodedModel.data?.foodID)
                        completion(true)
                    }
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }.resume()
    }
    
    // Helper function to determine MIME type based on the file extension
    private func mimeTypeForImage(_ imageName: String) -> String {
        let fileExtension = imageName.lowercased().split(separator: ".").last ?? ""
        
        switch fileExtension {
        case "jpg", "jpeg":
            return "image/jpeg"
        case "png":
            return "image/png"
        case "heic":
            return "image/heic"
        default:
            return "application/octet-stream"
        }
    }

    // Helper function to compress image
    private func compressImage(image: UIImage) -> Data? {
        var compressionQuality: CGFloat = 1.0
        var compressedData: Data?

        // Try compressing with quality from 100% down to 10%
        while compressionQuality > 0.1 {
            compressedData = image.jpegData(compressionQuality: compressionQuality)
            
            if let data = compressedData, data.count <= 1 * 1024 * 1024 { // 1 MB in bytes
                break
            }
            
            compressionQuality -= 0.1
        }
        
        return compressedData
    }
}

public struct MultipartRequest {
    public let boundary: String
    private let separator: String = "\r\n"
    private var data: Data
    
    public init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }
    
    private mutating func appendBoundarySeparator() {
        data.append("--\(boundary)\(separator)".data(using: .utf8) ?? Data())
    }
    
    private mutating func appendSeparator() {
        data.append(separator.data(using: .utf8) ?? Data())
    }
    
    private func disposition(_ key: String) -> String {
        return "Content-Disposition: form-data; name=\"\(key)\""
    }
    
    public mutating func add(key: String, value: String) {
        appendBoundarySeparator()
        data.append((disposition(key) + separator).data(using: .utf8) ?? Data())
        appendSeparator()
        data.append((value + separator).data(using: .utf8) ?? Data())
    }
    
    public mutating func add(key: String, fileName: String, fileMimeType: String, fileData: Data) {
        appendBoundarySeparator()
        data.append((disposition(key) + "; filename=\"\(fileName)\"" + separator).data(using: .utf8) ?? Data())
        data.append(("Content-Type: \(fileMimeType)" + separator + separator).data(using: .utf8) ?? Data())
        data.append(fileData)
        appendSeparator()
    }
    
    public var httpContentTypeHeadeValue: String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    public var httpBody: Data {
        var bodyData = data
        bodyData.append("--\(boundary)--".data(using: .utf8) ?? Data())
        return bodyData
    }
}
