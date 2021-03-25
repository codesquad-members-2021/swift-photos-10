import Foundation

class DecodedJsonData {
    var decodedData = [[String:Any]]()
    var date = [String]()
    var title = [String]()
    var image = [String]()
    
    func decodeJasonData() {
        let path = Bundle.main.path(forResource: "doodle", ofType: "json")
        if let data = try? String(contentsOfFile: path!).data(using: .utf8) {
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
            decodedData = json
        }
        for eachData in decodedData {
            image.append(eachData["image"] as! String)
            title.append(eachData["title"] as! String)
            date.append(eachData["date"] as! String)
        }
    }
}
