//
//  ChangePasswordController.swift
//  withoutStroyBoard_Entertainment_AmongUs
//
//  Created by 남궁광 on 2022/04/13.
//

import Foundation
import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {
    var newPasswordLabel: UILabel?

    var email: UILabel?
    var emailTextField: UITextField?
    
    var newPassword: UILabel?
    var newPasswordTextField: UITextField?
    
    var confirmnewPassword: UILabel?
    var confirmnewPasswordTextField: UITextField?
    
    var cancelButton: UIButton?
    var completeButton: UIButton?
    
    
    func addpicture(){
        let newPasswordLabel: UILabel = {
            let anewPasswordLabel = UILabel()
            anewPasswordLabel.text = "비밀번호 변경페이지 입니다."
            anewPasswordLabel.font = UIFont.systemFont(ofSize: 30,weight: .heavy)
            anewPasswordLabel.clipsToBounds = true
            anewPasswordLabel.textAlignment = .center
            anewPasswordLabel.numberOfLines = 1
            anewPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
            return anewPasswordLabel
        }()
        
        view.addSubview(newPasswordLabel)
        self.newPasswordLabel = newPasswordLabel
        
        let email:UILabel = {
           let aemail = UILabel()
            aemail.text = "이메일"
            aemail.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
            aemail.clipsToBounds = true
            aemail.textAlignment = .left
            aemail.numberOfLines = 1
            aemail.translatesAutoresizingMaskIntoConstraints = false
            return aemail
        }()
        
        view.addSubview(email)
        
        self.email = email
        
        let emailTextField: UITextField = {
            let aemailTextField = UITextField()
            aemailTextField.backgroundColor = .white
            aemailTextField.borderStyle = .roundedRect
            aemailTextField.autocorrectionType = .no
            return aemailTextField
        }()
        
        
        view.addSubview(emailTextField)
        
        self.emailTextField = emailTextField
        
        let stackView: UIStackView = {
           let astackView = UIStackView()
            
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(email)
        stackView.addArrangedSubview(emailTextField)
        
        let newPassword:UILabel = {
           let anewPassword = UILabel()
            anewPassword.text = "새로운 비밀번호"
            anewPassword.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
            anewPassword.clipsToBounds = true
            anewPassword.textAlignment = .left
            anewPassword.numberOfLines = 1
            anewPassword.translatesAutoresizingMaskIntoConstraints = false
            return anewPassword
        }()
        
        view.addSubview(newPassword)
        
        self.newPassword = newPassword
        
        let newPasswordTextField: UITextField = {
            let anewPasswordTextField = UITextField()
            anewPasswordTextField.backgroundColor = .white
            anewPasswordTextField.borderStyle = .roundedRect
            anewPasswordTextField.autocorrectionType = .no
            return anewPasswordTextField
        }()
        
        
        view.addSubview(newPasswordTextField)
        
        self.newPasswordTextField = newPasswordTextField
        
        
        let stackView_2: UIStackView = {
           let astackView = UIStackView()
            
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView_2)
        
        stackView_2.addArrangedSubview(newPassword)
        stackView_2.addArrangedSubview(newPasswordTextField)
        
        
        
        
        let confirmnewPassword:UILabel = {
           let aconfirmnewPassword = UILabel()
            aconfirmnewPassword.text = "이메일"
            aconfirmnewPassword.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
            aconfirmnewPassword.clipsToBounds = true
            aconfirmnewPassword.textAlignment = .left
            aconfirmnewPassword.numberOfLines = 1
            aconfirmnewPassword.translatesAutoresizingMaskIntoConstraints = false
            return aconfirmnewPassword
        }()
        
        view.addSubview(confirmnewPassword)
        
        self.confirmnewPassword = confirmnewPassword
        
        let confirmnewPasswordTextField: UITextField = {
            let aconfirmnewPasswordTextField = UITextField()
            aconfirmnewPasswordTextField.backgroundColor = .white
            aconfirmnewPasswordTextField.borderStyle = .roundedRect
            aconfirmnewPasswordTextField.autocorrectionType = .no
            return aconfirmnewPasswordTextField
        }()
        
        
        view.addSubview(confirmnewPasswordTextField)
        
        self.confirmnewPasswordTextField = confirmnewPasswordTextField
        
        
        let stackView_3: UIStackView = {
           let astackView = UIStackView()
            astackView.translatesAutoresizingMaskIntoConstraints = false
            astackView.axis = .vertical
            astackView.alignment = .fill
            astackView.distribution = .fill
            astackView.spacing = 10
            return astackView
        }()
        
        view.addSubview(stackView_3)
        
        stackView_3.addArrangedSubview(confirmnewPassword)
        stackView_3.addArrangedSubview(confirmnewPasswordTextField)

        //전체 스택합침.
        let totalStack: UIStackView = {
            let atotalstackView = UIStackView()
            
            atotalstackView.translatesAutoresizingMaskIntoConstraints = false
            atotalstackView.axis = .vertical
            atotalstackView.alignment = .fill
            atotalstackView.distribution = .fill
            atotalstackView.spacing = 15
            return atotalstackView
        }()
        
        view.addSubview(totalStack)
        
        totalStack.addArrangedSubview(newPasswordLabel)
        totalStack.addArrangedSubview(stackView)
        totalStack.addArrangedSubview(stackView_2)
        totalStack.addArrangedSubview(stackView_3)
        
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        totalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalStack.topAnchor.constraint(equalTo: view.topAnchor,constant: 120).isActive = true
        totalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        totalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        totalStack.spacing = 5
        
        
        let cancelButton: UIButton = {
            let acancelButton = UIButton()
            acancelButton.setTitle("취소", for: .normal)
            acancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            acancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside)
            acancelButton.setTitleColor(.systemBlue, for: .normal)
            return acancelButton
        }()
        
        view.addSubview(cancelButton)
        
        self.cancelButton = cancelButton
        
        let completeButton: UIButton = {
            let acompleteButton = UIButton()
            acompleteButton.setTitle("완료", for: .normal)
            acompleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
            acompleteButton.addTarget(self, action: #selector(self.completeButton(_:)), for: .touchUpInside)
            acompleteButton.setTitleColor(.systemBlue, for: .normal)
            return acompleteButton
        }()
        
        view.addSubview(completeButton)
        
        self.completeButton = completeButton
        
        let StackView_4: UIStackView = {
            let aStackView = UIStackView()
            
            aStackView.translatesAutoresizingMaskIntoConstraints = false
            aStackView.axis = .horizontal
            aStackView.alignment = .fill
            aStackView.distribution = .fillEqually
            aStackView.spacing = 30
            return aStackView
        }()
        
        view.addSubview(StackView_4)
        
        StackView_4.addArrangedSubview(cancelButton)
        StackView_4.addArrangedSubview(completeButton)
        
        StackView_4.translatesAutoresizingMaskIntoConstraints = false
        StackView_4.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        StackView_4.topAnchor.constraint(equalTo: totalStack.bottomAnchor,constant: 24).isActive = true
        StackView_4.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 24).isActive = true
        StackView_4.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -24).isActive = true
        StackView_4.spacing = 30
        
    }
    
    func completeAction(){
        let email = emailTextField?.text
        let newPass = newPasswordTextField?.text
        let confirmnewPass = confirmnewPasswordTextField?.text
        
        let param: Parameters = [
            "password": newPass!,
            "passwordCheck" : confirmnewPass!
        ]
        
        
        if !isVaildPass(newPass!){
            //비밀번호 형식 실패
            self.view.makeToast("비밀번호 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        
        if newPass != confirmnewPass{
            self.view.makeToast("비밀번호와 비밀번호 확인이 다릅니다.", duration: 1.0, position: .bottom)
            return
        }
        
        
        let URL = "http://3.37.123.140:8080/users/\(String(email!))/password"
        
        let alamo = AF.request(URL, method: .patch,parameters: param).validate(statusCode: 200..<300)
        
        
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "비밀번호가 변경되었습니다.",message: "",preferredStyle: UIAlertController.Style.alert)
                
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                
                
                alert.addAction(confirm)
                
                self.present(alert,animated: true,completion: nil)
                
                
                //통신실패
                case .failure(let error):
                    //print("error: \(String(describing: error.errorDescription))")
                let alert = UIAlertController(title:"서버에 문제가 있습니다.",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                        action in
                        //self.navigationController?.popViewController(animated: true)
                    })
                    
                    alert.addAction(confirm)
                    
                    self.present(alert,animated: true,completion: nil)
                }
                
            }
    }
    
    
    func isVaildPass(_ pass:String)->Bool{
        //비밀번호 가능한지 확인
        let passRefEx = "^[a-zA-Z0-9]{8,}$"
        let passTest = NSPredicate(format: "SELF MATCHES %@",passRefEx)
        return passTest.evaluate(with: pass)
        
    }
    
    @objc func cancelButton(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButton(_ sender: UIButton){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "비밀번호 변경하기"
        addpicture()
    }
    
}

