
import Foundation
import UIKit

class DoodleViewController : UICollectionViewController {
    
    private var image = ImageManager()
    private var clickedCell : CustomCell!
    
    override func viewDidLoad() {
        //Navigation Item
        super.viewDidLoad()
        self.navigationItem.title = "Doodles"
        self.collectionView.backgroundColor = .darkGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = .blue
        //Gesture
        let longTouchGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTouched(gesture:)))
        longTouchGesture.minimumPressDuration = 0.3
        collectionView.addGestureRecognizer(longTouchGesture)
        //RegisterCell
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        
    }
}

//MARK: -Cell configuration
extension DoodleViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.imageData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        DispatchQueue.global().async {
            guard let url = URL(string: self.image.urlToImage(from: indexPath.row)), let data = try? Data(contentsOf: url) else { return }
                        DispatchQueue.main.async {
                            cell.cellImageView.image = UIImage(data: data)
                        }
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

//MARK: -@objc Action
extension DoodleViewController {
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
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
