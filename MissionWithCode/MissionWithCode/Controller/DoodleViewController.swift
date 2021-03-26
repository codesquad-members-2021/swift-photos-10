import UIKit

class DoodleViewController: UICollectionViewController {
    
    private var imageManager = ImageManager()
    private lazy var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissbuttonTouched(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSelfView()
    }
    
    private func setUpSelfView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .darkGray
        navigationItem.title = "Doodle"
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        navigationItem.rightBarButtonItem = self.dismissButton
    }
}

//MARK: -CollectionView && Cells
extension DoodleViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageManager.imageData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        
        DispatchQueue.global().async {
            guard let url = URL(string: self.imageManager.urlToImage(from: indexPath.row)), let data = try? Data(contentsOf: url) else { return }
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

//MARK: -@obj Action
extension DoodleViewController {
    @objc func dismissbuttonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
