import UIKit
import Photos

class PhotoLibrary: NSObject, PHPhotoLibraryChangeObserver {
    
    private(set) var allPhotos: PHFetchResult<PHAsset>? = PHAsset.fetchAssets(with: nil)
    private let imageManager = PHCachingImageManager()
    
    func requestImage(cell: CustomCell, indexPath: IndexPath) {
        imageManager.requestImage(for: allPhotos![indexPath.row], targetSize: cell.intrinsicContentSize, contentMode: .aspectFill, options: nil, resultHandler: { cellImage, _ in
            if let image = cellImage {
                cell.cellImageView.image = image
            }
        })
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changed = changeInstance.changeDetails(for: allPhotos!) else { return }
        allPhotos = changed.fetchResultAfterChanges
        NotificationCenter.default.post(name: .assetChanged, object: self, userInfo: ["changed":changed])
    }
    
    func addImage(image: UIImage) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: nil)
    }
}

extension Notification.Name {
    static let assetChanged = Notification.Name("assetChanged")
}
