//
//  PlayerCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/05/15.
//

import UIKit

class PlayerCell: UICollectionViewCell {
    
    var playerImage: UIImageView?
    var nicknameLabel: UILabel?
    
    override var isSelected: Bool {
        willSet {
            guard let image = self.playerImage else { return }
            if newValue {
                image.layer.borderColor = UIColor.systemBlue.cgColor
                image.layer.borderWidth = 2.0
            }
            else {
                image.layer.borderColor = nil
                image.layer.borderWidth = 0.0
            }
        }
    }
    
    func addPlayerImage(width: CGFloat) {
        
        let image = UIImageView()
        
        self.contentView.addSubview(image)
        
        image.layer.cornerRadius = width/2
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.image = UIImage(named: "ic_user_loading")
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        image.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        
        
        self.playerImage = image
        
    }
    
    func addNicknameLabel() {
        
        guard let image = self.playerImage else {return}
        
        let label = UILabel()
        
        self.contentView.addSubview(label)
        
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        
        /*
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = 10
         */
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.nicknameLabel = label
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addPlayerImage(width: frame.width)
        self.addNicknameLabel()
    }
    
}
