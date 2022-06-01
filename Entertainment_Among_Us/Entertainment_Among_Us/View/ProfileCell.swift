//
//  ProfileCell.swift
//  Entertainment_Among_Us
//
//  Created by 남궁광 on 2022/06/01.
//

import UIKit

class ProfileCell: UICollectionViewCell {

    var image: UIImageView?
    var nickname: UILabel?
    var isReady: Bool = false {
        /* true면 셀 테두리에 준비 완료 표시 */
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
    var isRoomMaster: Bool = false {
        /* true면 프로필 이미지 테두리에 방장 표시 */
        willSet {
            guard let image = self.image else { return }
            if newValue {
                let color = UIColor.systemBlue.withAlphaComponent(0.7)
                image.layer.borderColor = color.cgColor
                image.layer.borderWidth = 2
            }
            else {
                image.layer.borderColor = nil
                image.layer.borderWidth = 0.0
            }
        }
    }
    
    func addImage(_ size: CGSize) {
        
        let image = UIImageView()
        let imageWidth = 2*size.height/3
        
        self.contentView.addSubview(image)
        
        
        image.backgroundColor = .white
        image.image = nil
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = imageWidth/2
        image.clipsToBounds = true
        
        /* 셀 크기에 따라 이미지 크기 및 오토 레이아웃 설정 */
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        image.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        image.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        
        self.image = image
    }
    
    func addLabel(_ size: CGSize) {
        
        guard let image = self.image else { return }
        
        let nickname = UILabel()
        
        self.contentView.addSubview(nickname)
        
        nickname.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        nickname.backgroundColor = .white
        nickname.layer.cornerRadius = 10
        nickname.clipsToBounds = true
        nickname.textAlignment = .center
        nickname.numberOfLines = 1
        nickname.adjustsFontSizeToFitWidth = true
        
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        nickname.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5).isActive = true
        nickname.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        nickname.widthAnchor.constraint(equalToConstant: size.width-10).isActive = true
        
        self.nickname = nickname
        
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

