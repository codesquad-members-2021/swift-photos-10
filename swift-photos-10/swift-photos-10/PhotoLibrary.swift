
import Foundation
import Photos


class PhotoLibrary : NSObject {
    
    private(set) var allPhotos : PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: nil)
    private let imageManager = PHCachingImageManager()
    
    func requestImage(cell: CustomCell, indexPath: IndexPath) {
        let asset = allPhotos.object(at: indexPath.row)
        imageManager.requestImage(for: asset, targetSize: cell.intrinsicContentSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            cell.cellImageView.image = image
        })
    }
    
    func updateFetchResult(updateResult: PHFetchResult<PHAsset>) {
        self.allPhotos = updateResult
    }
}
