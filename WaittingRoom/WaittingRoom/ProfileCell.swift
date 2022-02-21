//
//  ProfileCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/02/16.
//

import UIKit

class ProfileCell: UICollectionViewCell {

    var image: UIImageView?
    var nickname: UILabel?
    var isReady: Bool = false {
        willSet {
            if newValue {
                self.contentView.layer.borderColor = UIColor.systemBlue.cgColor
                self.contentView.layer.borderWidth = 2
            }
            else {
                self.contentView.layer.borderColor = nil
                self.contentView.layer.borderWidth = 0.0
            }
        }
        
    }
    
    func addImage(_ size: CGSize) {
        
        let image = UIImageView()
        
        self.contentView.addSubview(image)
        
        image.backgroundColor = .white
        image.image = nil
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = size.width/4
        image.clipsToBounds = true
        
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        image.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: size.width/2).isActive = true
        image.heightAnchor.constraint(equalToConstant: size.width/2).isActive = true
        
        
        self.image = image
    }
    
    func addLabel(_ size: CGSize) {
        
        guard let image = self.image else { return }
        
        let nickname = UILabel()
        
        self.contentView.addSubview(nickname)
        nickname.text = "닉네임"
        nickname.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        nickname.backgroundColor = .white
        nickname.layer.cornerRadius = 10
        nickname.clipsToBounds = true
        nickname.textAlignment = .center
        
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        nickname.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5).isActive = true
        nickname.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        nickname.widthAnchor.constraint(equalToConstant: size.width-10).isActive = true
        
        self.nickname = nickname
        
    }
    
    func blink() {
        
//        self.alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.0,
                       options: [.curveEaseInOut, .repeat, .autoreverse],
                       animations: { [weak self] in self?.alpha = 0.0 })
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray5
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        
        self.addImage(frame.size)
        self.addLabel(frame.size)
    }
    
}
