import Foundation
import UIKit

class CustomCell : UICollectionViewCell {
    
    private(set) var cellImageView = UIImageView()
    private(set) static var identifier = "customcell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureImageView()
    }
    
    private func configureImageView() {
        addSubview(cellImageView)
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        cellImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        cellImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
