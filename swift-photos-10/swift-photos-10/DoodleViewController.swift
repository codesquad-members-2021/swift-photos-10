
import Foundation
import UIKit

class DoodleViewController : UICollectionViewController {
    
    private var image = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Doodles"
        self.collectionView.backgroundColor = .darkGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = .blue
        
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(updateImage(notification:)), name: ImageManager.imageNoti, object: image)
        image.urlDataToImage()
    }
    
    @objc func updateImage(notification: Notification) {
        if let count = notification.userInfo?["image"] as? Int {
            DispatchQueue.main.async {
                self.collectionView.insertItems(at: [IndexPath(row: count-1, section: 0)])
            }
        }
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DoodleViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.imageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageSet = image.imageArray
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = .red
        for image in imageSet {
            cell.cellImageView.image = image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                return CGSize(width: 110, height: 50)
        }
}
