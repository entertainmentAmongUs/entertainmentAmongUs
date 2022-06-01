//
//  ChangePasswordViewController.swift
//  Entertainment_Among_Us
//
//  Created by 남궁광 on 2022/05/30.
//

import UIKit
import Toast_Swift
import Alamofire
import SnapKit

final class ChangePasswordViewController: UIViewController {
    var e_mail: String = ""
    var new_Pass: String = ""
    var confirm_new_Pass: String = ""
    var URL: String = ""
    
    private lazy var newPasswordLabel: UILabel = {
        let anewPasswordLabel = UILabel()
        anewPasswordLabel.text = "비밀번호 변경페이지 입니다."
        anewPasswordLabel.font = UIFont.systemFont(ofSize: 30,weight: .heavy)
        anewPasswordLabel.clipsToBounds = true
        anewPasswordLabel.textAlignment = .center
        anewPasswordLabel.numberOfLines = 1
        return anewPasswordLabel
    }()
    
    private lazy var email: UILabel = {
        let aemail = UILabel()
         aemail.text = "이메일"
         aemail.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
         aemail.clipsToBounds = true
         aemail.textAlignment = .left
         aemail.numberOfLines = 1
         return aemail
    }()
    private lazy var emailTextField: UITextField = {
        let aemailTextField = UITextField()
        aemailTextField.backgroundColor = .white
        aemailTextField.borderStyle = .roundedRect
        aemailTextField.autocorrectionType = .no
        aemailTextField.autocapitalizationType = .none
        return aemailTextField
    }()
    
    private lazy var stackView: UIStackView = {
        let astackView = UIStackView()
         astackView.translatesAutoresizingMaskIntoConstraints = false
         astackView.axis = .vertical
         astackView.alignment = .fill
         astackView.distribution = .fill
         astackView.spacing = 10
         return astackView
    }()
    
    private lazy var newPassword: UILabel = {
        let anewPassword = UILabel()
         anewPassword.text = "새로운 비밀번호"
         anewPassword.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
         anewPassword.clipsToBounds = true
         anewPassword.textAlignment = .left
         anewPassword.numberOfLines = 1
         return anewPassword
    }()
    
    private lazy var newpasswordTextField: UITextField = {
        let anewPasswordTextField = UITextField()
        anewPasswordTextField.backgroundColor = .white
        anewPasswordTextField.borderStyle = .roundedRect
        anewPasswordTextField.autocorrectionType = .no
        anewPasswordTextField.autocapitalizationType = .none
        return anewPasswordTextField
    }()
    
    private lazy var stackView_2: UIStackView = {
        let astackView = UIStackView()
         astackView.translatesAutoresizingMaskIntoConstraints = false
         astackView.axis = .vertical
         astackView.alignment = .fill
         astackView.distribution = .fill
         astackView.spacing = 10
         return astackView
    }()
    
    private lazy var confirmnewPassword: UILabel = {
        let aconfirmnewPassword = UILabel()
         aconfirmnewPassword.text = "새로운 비밀번호 확인"
         aconfirmnewPassword.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
         aconfirmnewPassword.clipsToBounds = true
         aconfirmnewPassword.textAlignment = .left
         aconfirmnewPassword.numberOfLines = 1
         return aconfirmnewPassword
    }()
    
    private lazy var confirmnewPasswordTextField: UITextField = {
        let aconfirmnewPasswordTextField = UITextField()
        aconfirmnewPasswordTextField.backgroundColor = .white
        aconfirmnewPasswordTextField.borderStyle = .roundedRect
        aconfirmnewPasswordTextField.autocorrectionType = .no
        aconfirmnewPasswordTextField.autocapitalizationType = .none
        return aconfirmnewPasswordTextField
    }()
    
    private lazy var stackView_3: UIStackView = {
        let astackView = UIStackView()
         astackView.translatesAutoresizingMaskIntoConstraints = false
         astackView.axis = .vertical
         astackView.alignment = .fill
         astackView.distribution = .fill
         astackView.spacing = 10
         return astackView
    }()
    private lazy var totalstackView: UIStackView = {
        let atotalstackView = UIStackView()
        atotalstackView.axis = .vertical
        atotalstackView.alignment = .fill
        atotalstackView.distribution = .fill
        atotalstackView.spacing = 15
        atotalstackView.translatesAutoresizingMaskIntoConstraints = false
        return atotalstackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let acancelButton = UIButton()
        acancelButton.setTitle("취소", for: .normal)
        acancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        acancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside)
        acancelButton.setTitleColor(.systemBlue, for: .normal)
        return acancelButton
    }()
    
    private lazy var completeButton: UIButton = {
        let acompleteButton = UIButton()
        acompleteButton.setTitle("완료", for: .normal)
        acompleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .bold)
        acompleteButton.addTarget(self, action: #selector(self.completeButton(_:)), for: .touchUpInside)
        acompleteButton.setTitleColor(.systemBlue, for: .normal)
        return acompleteButton
    }()
    private lazy var stackView_4:UIStackView = {
        let aStackView = UIStackView()
        aStackView.translatesAutoresizingMaskIntoConstraints = false
        aStackView.axis = .horizontal
        aStackView.alignment = .fill
        aStackView.distribution = .fillEqually
        aStackView.spacing = 30
        return aStackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }
    
}

private extension ChangePasswordViewController {
    func setupLayout(){
        [
            newPasswordLabel,
            email,
            emailTextField,
            stackView,
            newPassword,
            newpasswordTextField,
            stackView_2,
            confirmnewPassword,
            confirmnewPasswordTextField,
            stackView_3,
            totalstackView,
            cancelButton,
            completeButton,
            stackView_4
        ].forEach{view.addSubview($0)}
        
        [
            email,
            emailTextField
        ].forEach{stackView.addArrangedSubview($0)}
        
        [
            newPassword,
            newpasswordTextField
        ].forEach{stackView_2.addArrangedSubview($0)}
        
        [
            confirmnewPassword,
            confirmnewPasswordTextField
        ].forEach{stackView_3.addArrangedSubview($0)}
        
        [
            newPasswordLabel,
            stackView,
            stackView_2,
            stackView_3
        ].forEach{ totalstackView.addArrangedSubview($0)}
        
        [
            cancelButton,
            completeButton
        ].forEach{stackView_4.addArrangedSubview($0)}
        
        totalstackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(120)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        totalstackView.spacing = 5
        
        stackView_4.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(totalstackView.snp.bottom).offset(24)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        stackView_4.spacing = 30
        
    }
    
}

private extension ChangePasswordViewController {
    func isValidEmail(_ email:String) ->Bool{
        //이메일 가능한지 확인
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHes %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    func isVaildPass(_ pass:String)->Bool{
        //비밀번호 가능한지 확인
        let passRefEx = "^[a-zA-Z0-9]{8,}$"
        let passTest = NSPredicate(format: "SELF MATCHES %@",passRefEx)
        return passTest.evaluate(with: pass)
    }
    
    func completeAction(){
        self.e_mail = emailTextField.text ?? ""
        self.new_Pass = newpasswordTextField.text ?? ""
        self.confirm_new_Pass = confirmnewPasswordTextField.text ?? ""
        
        let param: Parameters = [
            "password": self.new_Pass,
            "passwordCheck" : self.confirm_new_Pass
        ]
        
        if !isVaildPass(self.new_Pass){
            //비밀번호 형식 실패
            self.view.makeToast("비밀번호 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
            return
        }
        if self.new_Pass != self.confirm_new_Pass{
            self.view.makeToast("비밀번호와 비밀번호 확인이 다릅니다.", duration: 1.0, position: .bottom)
            return
        }
        
        
        self.URL = "http://52.78.47.148:8080/users/\(String(self.e_mail))/password"
        
        
    
        let alamo = AF.request(self.URL, method: .patch,parameters: param,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
        
        alamo.responseString() { response in
            switch response.result
            {
            //통신성공
            case .success:
                let alert = UIAlertController(title: "\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message: "",preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            //통신실패
            case .failure(let error):
                let alert = UIAlertController(title:"\(String(describing: String(data: response.data!, encoding: String.Encoding.utf8)!))",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                    action in
                })
                alert.addAction(confirm)
                self.present(alert,animated: true,completion: nil)
            }
        }
    }
    
    
    @objc func cancelButton(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButton(_ sender: UIButton){
        self.completeAction()
    }
}
