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
        
        
        let picker = UIButton(type: .system)
        
        contentView.addSubview(picker)
        
        picker.setTitleColor(.black, for: .normal)
        picker.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        picker.backgroundColor = .systemGray6
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 5
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        picker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
        self.maxUserNumberButton = picker
        
        
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
