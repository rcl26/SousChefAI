import Foundation
import UIKit

class LogMealService {
    private let apiKey = APIKeys.logMealAPIKey // Using the secure APIKeys struct
    private let endpoint = "https://api.logmeal.com/v2/image/segmentation/complete/latest" // Example endpoint

    // Function to analyze an image
    func analyzeFoodImage(image: UIImage, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=boundary", forHTTPHeaderField: "Content-Type")

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])))
            return
        }

        request.httpBody = createMultipartBody(imageData: imageData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                // Decode the JSON response
                let result = try JSONDecoder().decode(LogMealResponse.self, from: data)
                let foodItems = result.foodItems.map { $0.name }
                completion(.success(foodItems))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Helper function to create multipart form data
    private func createMultipartBody(imageData: Data) -> Data {
        let boundary = "boundary"
        var body = Data()
        let lineBreak = "\r\n"

        body.append("--\(boundary)\(lineBreak)")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\(lineBreak)")
        body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)")
        body.append(imageData)
        body.append("\(lineBreak)--\(boundary)--\(lineBreak)")

        return body
    }
}

// Define the response structure
struct LogMealResponse: Decodable {
    let foodItems: [FoodItem]
}

struct FoodItem: Decodable {
    let name: String
}
