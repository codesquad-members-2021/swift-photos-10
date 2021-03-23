//
//  ViewController.swift
//  swift-photos-10
//
//  Created by user on 2021/03/22.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource {
    
    private var allPhotos : PHFetchResult<PHAsset>?
    private var imageManager : PHCachingImageManager!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCell else {
            return UICollectionViewCell()
        }
//        cell.backgroundColor = UIColor.random()
        let asset = self.allPhotos?.object(at: indexPath.item)
        
        cell.representedAssetIdentifier = asset?.localIdentifier
        imageManager.requestImage(for: asset!, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset?.localIdentifier {
                self.cellImage.image = image
            }
        })
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.allPhotos = PHAsset.fetchAssets(with: nil)
        
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
