import UIKit

class DoodleViewController: UICollectionViewController {
    
    private var imageManager = ImageManager()
    private var selectedImage: UIImage!
    private let app = UIApplication.shared.delegate as! AppDelegate
    private lazy var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissbuttonTouched(_:)))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSelfView()
        setUplongPressGesture()
    }
    
    private func setUpSelfView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .darkGray
        navigationItem.title = "Doodle"
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        navigationItem.rightBarButtonItem = self.dismissButton
    }
    
    private func setUplongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longGesturebuttonToucehd(_:)))
        collectionView.addGestureRecognizer(gesture)
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
    
    @objc func dismissbuttonTouched(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func longGesturebuttonToucehd(_ gesture: UILongPressGestureRecognizer) {
        let menuController = UIMenuController.shared
        let menuItem = UIMenuItem(title: "Save", action: #selector(saveItemTabbed))
        menuController.menuItems = [menuItem]
        
        if gesture.state != .began { return }
        let location = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location), let cell = collectionView.cellForItem(at: indexPath) as? CustomCell else { return }
        cell.becomeFirstResponder()
        
        menuController.showMenu(from: cell, rect: collectionView.layoutAttributesForItem(at: indexPath)!.bounds)
        selectedImage = cell.cellImageView.image
    }
    
    @objc func saveItemTabbed() {
        app.photoManager.addImage(image: selectedImage)
        self.dismiss(animated: true, completion: nil)
    }
}
