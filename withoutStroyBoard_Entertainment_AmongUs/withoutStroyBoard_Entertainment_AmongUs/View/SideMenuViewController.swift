//
//  SideMenuViewController.swift
//  withoutStroyBoard_Entertainment_AmongUs
//
//  Created by 남궁광 on 2022/03/04.
//

import UIKit
import SideMenu


class SideMenuViewController: UIViewController {
    var scoreLabel: UILabel?
    var score: UILabel?
    
    var gameruleButton: UIButton?
    var friendTableView: UITableView?
    let friendIdentifier = "Friend"
    
    
    var settingButton: UIButton?
    var logoutButton: UIButton?
    
    
    func addpicture(){
        let scoreLabel: UILabel = {
            let ascoreLabel = UILabel()
            ascoreLabel.text = "점수"
            ascoreLabel.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
            ascoreLabel.clipsToBounds = true
            ascoreLabel.textAlignment = .left
            ascoreLabel.numberOfLines = 1
            ascoreLabel.textColor = .white
            ascoreLabel.translatesAutoresizingMaskIntoConstraints = false
            return ascoreLabel
        }()
        
        view.addSubview(scoreLabel)
        self.scoreLabel = scoreLabel
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 75).isActive = true
        scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        let score: UILabel = {
            let ascore = UILabel()
            ascore.text = "20437점"
            ascore.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
            ascore.clipsToBounds = true
            ascore.textAlignment = .left
            ascore.numberOfLines = 1
            ascore.textColor = .white
            ascore.translatesAutoresizingMaskIntoConstraints = false
            return ascore
        }()
        
        view.addSubview(score)
        self.score = score
        
        score.translatesAutoresizingMaskIntoConstraints = false
        score.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        score.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 20).isActive = true
        score.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        score.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
    }
    func addgamerule(){
        guard let score = self.score else { return }
        let gamerule: UIButton = {
            let agamerule = UIButton()
            agamerule.setTitle("게임 설명 버튼", for: .normal)
            agamerule.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            agamerule.addTarget(self, action: #selector(self.explainButton(_:)),for: .touchUpInside)
            agamerule.setTitleColor(.systemBlue, for: .normal)
            return agamerule
        }()
        
        view.addSubview(gamerule)
        self.gameruleButton = gamerule
        gamerule.translatesAutoresizingMaskIntoConstraints = false
        gamerule.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gamerule.topAnchor.constraint(equalTo: score.bottomAnchor,constant: 20).isActive = true
        gamerule.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        gamerule.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        
    }
    
    
    func addfriendList(){
        guard let gameruleButton = gameruleButton else { return }

        let table = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: gameruleButton.bottomAnchor,constant: 20).isActive = true
        
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 12).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        self.friendTableView = table
        
    }
    
    func addButton(){
        guard let friendTableView = friendTableView else { return }
        
        let setting: UIButton = {
            let asetting = UIButton()
            asetting.setTitle("Setting", for: .normal)
            asetting.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            asetting.addTarget(self, action: #selector(self.settingButton(_:)),for: .touchUpInside)
            asetting.setTitleColor(.systemBlue, for: .normal)
            return asetting
        }()
        
        view.addSubview(setting)
        self.settingButton = setting
        setting.translatesAutoresizingMaskIntoConstraints = false
        setting.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setting.topAnchor.constraint(equalTo: friendTableView.bottomAnchor,constant: 20).isActive = true
        setting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        setting.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        
        let logout: UIButton = {
            let alogout = UIButton()
            alogout.setTitle("뒤로가기", for: .normal)
            alogout.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            alogout.addTarget(self, action: #selector(self.logoutButton(_:)),for: .touchUpInside)
            alogout.setTitleColor(.systemBlue, for: .normal)
            return alogout
        }()
        
        view.addSubview(logout)
        self.logoutButton = logout
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logout.topAnchor.constraint(equalTo: setting.bottomAnchor,constant: 20).isActive = true
        logout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        logout.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -12).isActive = true
        

        
    }
    
    @objc func explainButton(_ sender: UIButton) {
        let explainButtonView = ExplainButtonController()
        explainButtonView.modalTransitionStyle = .crossDissolve
        explainButtonView.modalPresentationStyle = .overCurrentContext
        
        present(explainButtonView,animated: true, completion: nil)
        
    }
    
    @objc func settingButton(_ sender: UIButton){
        //아직미완
    }
    
    @objc func logoutButton(_ sender: UIButton){
        //self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popToRootViewController(animated: true)
        self.view.window!.rootViewController?.dismiss(animated: false,completion: nil)
        
        
        
    }
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addpicture()
        addgamerule()
        addfriendList()
        addButton()
    }
    



}
