import UIKit
import Photos

class PhotoCollectionView: UICollectionView {
    
    private var flowLayout = UICollectionViewFlowLayout()
    private let app = UIApplication.shared.delegate as! AppDelegate
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        configureCollectionView()
        PHPhotoLibrary.shared().register(app.photoManager)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        dataSource = self
        delegate = self
        register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
    }
}


//MARK: -CollectionView
extension PhotoCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //Adjust Counts of Cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app.photoManager.allPhotos!.count
    }
    
    // ReusableCell && CellBackgroundColor && ImageManager
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        app.photoManager.requestImage(cell: cell, indexPath: indexPath)
        return cell
    }
    
    //EdgeInsets of Each Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    //Size of Each Cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
