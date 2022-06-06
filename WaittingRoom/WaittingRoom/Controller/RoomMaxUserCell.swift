//
//  MaxUserCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/05.
//

import UIKit

class RoomMaxUserCell: UITableViewCell {

    var maxUserLabel: UILabel?
    var maxUserNumberButton: UIButton?
    
    func addView() {
        
        let label = UILabel()
        
        contentView.addSubview(label)
        
        label.text = "최대 인원"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  15).isActive = true
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        self.maxUserLabel = label
        
        
        let button = UIButton(type: .system)
        
        contentView.addSubview(button)
        
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.backgroundColor = .systemGray6
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
        self.maxUserNumberButton = button
        
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
    }
}
