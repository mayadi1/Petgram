

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    private var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        image = nil
        
        if let cachedImage = imageCache[urlString] {
            image = cachedImage
            print("Loading image from cache")
            return
        }
        print("Downloading image from net", urlString)

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage { return }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    
    }
}
