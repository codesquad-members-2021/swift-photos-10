
import Foundation
import UIKit

class DoodleViewController : UICollectionViewController {
    
    private var image = ImageManager()
    private var clickedCell : CustomCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Doodles"
        self.collectionView.backgroundColor = .darkGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = .blue
        
        let longTouchGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTouched(gesture:)))
        longTouchGesture.minimumPressDuration = 0.3
        collectionView.addGestureRecognizer(longTouchGesture)
        
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
    
    @objc func closeButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func longTouched(gesture: UIGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: point)
        else {
            return
        }
        let cell = self.collectionView.cellForItem(at: indexPath) as! CustomCell
        self.clickedCell = cell
        cell.becomeFirstResponder()
        
        let savedMenuItem = UIMenuItem(title: "Save", action: #selector(saveImage))
        UIMenuController.shared.menuItems = [savedMenuItem]
        UIMenuController.shared.showMenu(from: collectionView, rect: cell.frame)
    }
    
    @objc func saveImage(){
        if let image = clickedCell.cellImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
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
