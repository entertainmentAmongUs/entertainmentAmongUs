//
//  RoomSubjectCell.swift
//  WaittingRoom
//
//  Created by 김윤수 on 2022/06/05.
//

import UIKit

class RoomSubjectCell: UITableViewCell {
    
    var subejctLabel: UILabel?
    var subjectButton: UIButton?
    var categoryButton: UIButton?
    
    func addView() {
        
        let label = UILabel()
        
        contentView.addSubview(label)
        
        label.text = "주제 선택"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  15).isActive = true
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        
        let subject = UIButton(type: .system)
        
        
        subject.setTitleColor(.black, for: .normal)
        subject.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        subject.backgroundColor = .systemGray6
        subject.clipsToBounds = true
        subject.layer.cornerRadius = 5
        
        
        self.subjectButton = subject
        
        
        let category = UIButton(type: .system)
        

        category.setTitleColor(.black, for: .normal)
        category.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        category.backgroundColor = .systemGray6
        category.clipsToBounds = true
        category.layer.cornerRadius = 5
        
        self.categoryButton = category
        
        
        let stackView = UIStackView(arrangedSubviews: [subject, category])
        
        contentView.addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
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
