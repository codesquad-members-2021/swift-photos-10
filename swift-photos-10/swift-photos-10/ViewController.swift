import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var photoAlbum = PhotoLibrary()
    private let app = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        self.present(app.navigationController, animated: true, completion: nil)
    }
    
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoAlbum.allPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        self.photoAlbum.requestImage(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension ViewController : PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let changes = changeInstance.changeDetails(for: self.photoAlbum.allPhotos) {
                self.photoAlbum.updateFetchResult(updateResult: changes.fetchResultAfterChanges)
                self.photoCollectionView.reloadData()
            }
        }
    }
}
