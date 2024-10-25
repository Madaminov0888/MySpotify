//
//  MediaDownloader.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 27/09/24.
//

import Foundation
import UIKit


class MediaDownloader {
    
    func downloadImage(url: String) async throws -> UIImage {
        guard let url = URL(string: url) else { throw URLError(.badURL) }
        let (data, response) = try await URLSession.shared.data(from: url)
        let checkedData = try responseHandler(response: response, data: data)
        let image = UIImage(data: checkedData)
        return image ?? UIImage()
    }
    
    
    //MARK: -private functions
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func responseHandler(response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print("Error: HTTP request failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            print(" Error Raw response data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
            throw URLError(.badServerResponse)
        }
//        print(" SUCCESS Raw response data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
        return data
    }
}
