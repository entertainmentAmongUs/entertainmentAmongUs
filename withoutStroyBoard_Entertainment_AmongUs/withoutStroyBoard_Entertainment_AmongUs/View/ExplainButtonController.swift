//
//  ExplainButtonController.swift
//  withoutStroyBoard_Entertainment_AmongUs
//
//  Created by 남궁광 on 2022/03/22.
//

import UIKit


class ExplainButtonController: UIViewController{
    var contentView: UIView?
    
    var explainLabel: UILabel?
    func addContentView(){
        let content = UIView()
        
        self.view.addSubview(content)
        
        content.backgroundColor = .white
        content.layer.cornerRadius = 30
        content.clipsToBounds = true
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.heightAnchor.constraint(equalToConstant: 300).isActive = true
        content.widthAnchor.constraint(equalToConstant: 300).isActive = true
        content.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        content.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        self.contentView = content
        
    }
    
    func addexplain(){
        guard let content = self.contentView else { return }

        let explainLabel = UILabel()
        content.addSubview(explainLabel)

        explainLabel.text =
        "게임 설명을 아주 길게 적어볼까나? 아주 길게말이지? \\n 그러면 놀랄려나?"
        explainLabel.backgroundColor = .white
        explainLabel.font = UIFont.systemFont(ofSize: 12,weight: .heavy)
        explainLabel.clipsToBounds = true
        explainLabel.textAlignment = .left
        explainLabel.numberOfLines = 1
        
        explainLabel.translatesAutoresizingMaskIntoConstraints = false
        explainLabel.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        explainLabel.topAnchor.constraint(equalTo: content.topAnchor,constant: 10).isActive = true
        explainLabel.leadingAnchor.constraint(equalTo: content.leadingAnchor,constant: 5).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: content.trailingAnchor,constant: -5).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white.withAlphaComponent(0.55)
        addContentView()
        addexplain()
    }
    
}
