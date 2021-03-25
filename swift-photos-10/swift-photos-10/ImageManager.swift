import Foundation
import UIKit

class ImageManager {
    
    private var decodedData = [[String:Any]]()
    private var imageData = [ImageData]()
    private(set) var imageArray = [UIImage]()
    static var imageNoti = Notification.Name.init("image")
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
    
    func urlDataToImage() {
        print("url")
        DispatchQueue.global().async {
            for data in self.imageData {
                let url = URL(string: data.image!)!
                if let data = try? Data(contentsOf: url) {
                    let image = UIImage(data: data)!
                    self.imageArray.append(image)
                    NotificationCenter.default.post(name: ImageManager.imageNoti, object: self,userInfo: ["image": self.imageArray.count])
                }
            }
        }
    }
}
