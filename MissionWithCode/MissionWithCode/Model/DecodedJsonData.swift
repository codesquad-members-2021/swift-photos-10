import Foundation

class DecodedJsonData {
    private var decodedData = [[String:Any]]()
    var imageData = [ImageData]()
    
    func decodeJasonData() {
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
}
