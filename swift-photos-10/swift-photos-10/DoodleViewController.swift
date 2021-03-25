
import Foundation
import UIKit

class DoodleViewController : UICollectionViewController {
    
    private var image = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Doodles"
        self.collectionView.backgroundColor = .darkGray
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage(notification:)), name: ImageManager.imageNoti, object: image)
        image.urlDataToImage()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.imageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red

        return cell
    }
    
    @objc func updateImage(notification: Notification) {
        if let count = notification.userInfo?["image"] as? Int {
            DispatchQueue.main.async {
                self.collectionView.insertItems(at: [IndexPath(row: count-1, section: 0)])
            }
        }
    }
}
