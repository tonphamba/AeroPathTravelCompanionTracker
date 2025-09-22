import Foundation
import UIKit

struct PhotoData: Identifiable, Codable {
    let id = UUID()
    let imageData: Data
    let caption: String
    let dateAdded: Date
    
    init(image: UIImage, caption: String = "") {
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        self.caption = caption
        self.dateAdded = Date()
    }
    
    var uiImage: UIImage? {
        UIImage(data: imageData)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: dateAdded)
    }
}
