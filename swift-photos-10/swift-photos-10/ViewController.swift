import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource {
    
    private var allPhotos : PHFetchResult<PHAsset>!
    private var imageManager = PHCachingImageManager()
    private var library = PHPhotoLibrary.shared()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = UIColor.random()
        let asset = self.allPhotos.object(at: indexPath.item)
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: cell.intrinsicContentSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.cellImageView.image = image
            }
        })
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allPhotos = PHAsset.fetchAssets(with: nil)
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            library.register(self)
        default:
            break
        }
    }
}

extension ViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print("ok")
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}
