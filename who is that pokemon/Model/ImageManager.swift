//
//  ImageManager.swift
//  who is that pokemon
//
//  Created by Andres Landazabal on 2025/05/31.
//

import Foundation

protocol ImageManagerDelegate {
    func didUpdateImage(images: ImageModel)
    func didFailWithErrorImage(error: Error)
}

struct ImageManager {
  
    var delegate: ImageManagerDelegate?
    
    func fetchImage(url: String){
        performRequest(with: url)
    }
    
    private func performRequest(with urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithErrorImage(error: error)
                    return
                }
                if let safeData = data {
                    if let images = self.parseJSON(imageData: safeData) {
                        self.delegate?.didUpdateImage(images: images)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(imageData: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ImageData.self, from: imageData)
            let imageUrl = decodedData.sprites?.other?.officialArtwork?.frontDefault ?? ""
            return ImageModel(imageUrl: imageUrl)
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
