import Foundation
import UIKit

class ImageManager {
    
    private var decodedData = [[String:Any]]()
    private(set) var imageData = [ImageData]()
    
    init() {
        decodeJasonData()
    }
    
    private func decodeJasonData() {
        let path = Bundle.main.path(forResource: "doodle", ofType: "json")
        if let data = try? String(contentsOfFile: path!).data(using: .utf8) {
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
            decodedData = json
        }
        for eachData in decodedData {
            let image = eachData["image"] as! String
            let title = eachData["title"] as! String
            let date = eachData["date"] as! String
            imageData.append(ImageData(image: image, title: title, date: date))
        }
    }
    
    func urlToImage(from index: Int) -> String {
            return imageData[index].image
        }
}
