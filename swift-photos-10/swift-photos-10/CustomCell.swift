
import Foundation
import UIKit

class CustomCell : UICollectionViewCell {
    var representedAssetIdentifier: String!
    private(set) var cellImageView = UIImageView()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureImageView()
    }
    
    private func configureImageView() {
        self.addSubview(cellImageView)
        let imageViewWidth = NSLayoutConstraint(item: cellImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let imageViewHeight = NSLayoutConstraint(item: cellImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        cellImageView.addConstraints([imageViewWidth, imageViewHeight])
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        cellImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        cellImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
