import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource {
    
    private var allPhotos : PHFetchResult<PHAsset>!
    private var imageManager = PHCachingImageManager()
    private var library = PHPhotoLibrary.shared()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = UIColor.random()
        let asset = self.allPhotos.object(at: indexPath.item)
       
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.cellImageView.image = image
            }
        })
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allPhotos = PHAsset.fetchAssets(with: nil)
        
    }

    func save(image: UIImage) {
        library.performChanges({
            let _ = PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: nil)
    }
    
    func delete(asset: PHAsset) {
        library.performChanges({
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
        }, completionHandler: nil)
    }
    
    func toggleFavoriteForAsset(asset: PHAsset) {
        library.performChanges({
            let request = PHAssetChangeRequest(for: asset)
            request.isFavorite = !asset.isFavorite
        }, completionHandler: nil)
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
