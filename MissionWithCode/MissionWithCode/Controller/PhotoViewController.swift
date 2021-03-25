import UIKit
import Photos

class PhotoViewController: UIViewController {
    
    private var photoCollectionView = PhotoCollectionView()
    private var moveNextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonTouched(_:)))
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Photos"
        initSubViews()
        addObserver()
    }
    
    private func initSubViews() {
        view.addSubview(photoCollectionView)
        configurePhotoCelloctionView()
        navigationItem.leftBarButtonItem = self.moveNextButton
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadViewdata(_:)), name: .assetChanged, object: nil)
    }
}

//MARK: -Configruration
extension PhotoViewController {
    
    private func configurePhotoCelloctionView() {
        photoCollectionView.backgroundColor = UIColor.clear
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
}

//MARK: -@objc Action

extension PhotoViewController {
    
    @objc func reloadViewdata(_ notification: Notification) {

        DispatchQueue.main.async {
            let collectionView = self.photoCollectionView
            if let changes = notification.userInfo?["changed"] as? PHFetchResultChangeDetails<PHAsset> {
                if changes.hasIncrementalChanges {
                    collectionView.performBatchUpdates({
                        if let removed = changes.removedIndexes, removed.count > 0 {
                            collectionView.deleteItems(at: removed.map{ IndexPath(item: $0, section: 0)})
                        }
                        if let inserted = changes.insertedIndexes, inserted.count > 0 {
                            collectionView.insertItems(at: inserted.map{ IndexPath(item: $0, section: 0)})
                        }
                        if let changed = changes.changedIndexes, changed.count > 0 {
                            collectionView.reloadItems(at: changed.map{ IndexPath(item: $0, section: 0)})
                        }
                        changes.enumerateMoves { fromIndex, toIndex in
                            collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                    to: IndexPath(item: toIndex, section: 0))
                        }
                    })
                } else {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    @objc private func buttonTouched(_ sender: Any) {
        
    }
}

