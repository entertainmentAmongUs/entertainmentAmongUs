//
//  FindPassword.swift
//  Entertainment_Among_Us
//
//  Created by 남궁광 on 2022/05/30.
//

import UIKit
import Toast_Swift
import Alamofire
import SnapKit

final class FindpasswordViewController: UIViewController {
    var e_mail: String = ""
    var certifica_tion: String = ""
    var URL: String = ""
    
    private lazy var findPasswordLabel: UILabel = {
        let afindPasswordLabel = UILabel()
         afindPasswordLabel.text = "아이디/비밀번호 찾기"
         afindPasswordLabel.font = UIFont.systemFont(ofSize: 30,weight: .heavy)
         afindPasswordLabel.clipsToBounds = true
         afindPasswordLabel.textAlignment = .center
         afindPasswordLabel.numberOfLines = 1
         afindPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
         return afindPasswordLabel
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
    private lazy var certification: UILabel = {
        let acertification = UILabel()
         acertification.text = "인증번호"
         acertification.font = UIFont.systemFont(ofSize: 17,weight: .heavy)
         acertification.clipsToBounds = true
         acertification.textAlignment = .left
         acertification.numberOfLines = 1
         return acertification
    }()
    
    private lazy var certificationTextField: UITextField = {
        let acertificationTextField = UITextField()
        acertificationTextField.backgroundColor = .white
        acertificationTextField.borderStyle = .roundedRect
        acertificationTextField.autocorrectionType = .no
        acertificationTextField.autocapitalizationType = .none
        return acertificationTextField
    }()
    
    private lazy var stackView_2: UIStackView = {
        let astackView = UIStackView()
         astackView.translatesAutoresizingMaskIntoConstraints = false
         astackView.axis = .vertical
         astackView.alignment = .fill
         astackView.distribution = .fill
         astackView.spacing = 10
        astackView.isHidden = true
         return astackView
    }()
    
    private lazy var totalstack: UIStackView = {
        let atotalstackView = UIStackView()
        atotalstackView.translatesAutoresizingMaskIntoConstraints = false
        atotalstackView.axis = .vertical
        atotalstackView.alignment = .fill
        atotalstackView.distribution = .fill
        atotalstackView.spacing = 15
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
    
    private lazy var stackView_3: UIStackView = {
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
        self.view.backgroundColor = .white
        self.navigationItem.title = "아이디/비밀번호 찾기"
        setupLayout()
    }

    
}
private extension FindpasswordViewController {
    func setupLayout(){
        [
            findPasswordLabel,
            email,
            emailTextField,
            stackView,
            certification,
            certificationTextField,
            stackView_2,
            totalstack,
            cancelButton,
            completeButton,
            stackView_3,
        ].forEach{view.addSubview($0)}
        
        [
            email,
            emailTextField
        ].forEach{stackView.addArrangedSubview($0)}
        
        [
            certification,
            certificationTextField
        ].forEach{stackView_2.addArrangedSubview($0)}
        
        [
            findPasswordLabel,
            stackView,
            stackView_2
        ].forEach{totalstack.addArrangedSubview($0)}
        
        [
            cancelButton,
            completeButton
        ].forEach{ stackView_3.addArrangedSubview($0)}
        
        totalstack.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(120)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        stackView_3.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(totalstack.snp.bottom).offset(24)
            $0.leading.equalTo(24)
            $0.trailing.equalTo(-24)
        }
        
        
        totalstack.spacing = 5
        stackView_3.spacing = 30


    }

}

private extension FindpasswordViewController {
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
    //
    @objc func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)

    }
    
    @objc func completeButton(_ sender: UIButton){
        let stackView_3 = self.stackView_2
        
        
        if stackView_3.isHidden == true {
            self.e_mail = emailTextField.text ?? ""
            
            if !isValidEmail(self.e_mail){
                //email 형식 실패
                self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
                return
            }
            self.URL = "http://52.78.47.148:8080/emails/\(String(self.e_mail))/email"
            let param: Parameters = [
                "email" : self.e_mail
            ]
            let alamo = AF.request(URL, method: .get, parameters: param).validate(statusCode: 200..<300)
            //결과값으로 문자열을 받을 때 사용
            alamo.responseString() { response in
                switch response.result
                {
                //통신성공
                case .success:
                    let alert = UIAlertController(title: "인증번호가 전송되었습니다.!",message: "",preferredStyle: UIAlertController.Style.alert)
                    let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                        action in
                        stackView_3.isHidden = false
                    })
                    alert.addAction(confirm)
                    self.present(alert,animated: true,completion: nil)
                //통신실패
                case .failure(let error):
                        //print("error: \(String(describing: error.errorDescription))")
                    let alert = UIAlertController(title:"이메일을 확인하세요.",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                        let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                            action in
                            //self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(confirm)
                        self.present(alert,animated: true,completion: nil)
                    }
                }
        }
        else{
            self.e_mail = emailTextField.text ?? ""
            self.certifica_tion = certificationTextField.text ?? ""
            let param: Parameters = [
                "code": self.certifica_tion,
                "email" : self.e_mail
                
            ]
            if !isValidEmail(self.e_mail){
                //email 형식 실패
                self.view.makeToast("이메일 형식이 잘못되었습니다.", duration: 1.0, position: .bottom)
                return
            }
            self.URL = "http://52.78.47.148:8080/emails/email-code"
            let alamo = AF.request(self.URL, method: .post, parameters: param,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
            //결과값으로 문자열을 받을 때 사용
            alamo.responseString() { response in
                switch response.result
                {
                //통신성공
                case .success:
                    let alert = UIAlertController(title: "비밀번호 변경페이지로 넘어갑니다..",message: "",preferredStyle: UIAlertController.Style.alert)
                    
                    let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                        action in
                        //비밀번호 페이지 만들자.
                        let chagnePasswordViewController = ChangePasswordViewController()
                        self.navigationController?.pushViewController(chagnePasswordViewController, animated: true)
                    })
                    alert.addAction(confirm)
                    self.present(alert,animated: true,completion: nil)
                //통신실패
                case .failure(let error):
                        //print("error: \(String(describing: error.errorDescription))")
                    let alert = UIAlertController(title:"인증 코드를 다시 확인하세요..",message: "\(String(describing: error.errorDescription))",preferredStyle: UIAlertController.Style.alert)
                        let confirm = UIAlertAction(title: "확인", style: .default,handler: {
                            action in
                        })
                        alert.addAction(confirm)
                        self.present(alert,animated: true,completion: nil)
                    }
                }
        }
        
    }
    
}
