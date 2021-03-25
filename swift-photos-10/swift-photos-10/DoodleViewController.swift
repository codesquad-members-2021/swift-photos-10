
import Foundation
import UIKit

class DoodleViewController : UICollectionViewController {
    
    private var image = ImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Doodles"
        self.collectionView.backgroundColor = .darkGray
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.systemRed
        return cell
    }
}
