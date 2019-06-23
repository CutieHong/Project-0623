//
//  LoginViewController.swift
//  Project02
//
//  Created by swucomputer on 22/06/2019.
//  Copyright © 2019 swucomputer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var loginID: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginID {
            textField.resignFirstResponder()
            self.loginPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }

    @IBAction func loginPressed() {
        if loginID.text == "" {
            labelStatus.text = "ID를 입력해주세요."; return;
        }
        if loginPassword.text == "" {
            labelStatus.text = "비밀번호를 입력해주세요."; return;
        }
        
        let urlString: String = "http://condi.swu.ac.kr/student/login/loginUser.php"
        
        guard let requestURL = URL(string: urlString) else {
            return }
        self.labelStatus.text = " "
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + loginID.text! + "&password=" + loginPassword.text!
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData,
                                                                      options:.allowFragments) as? [String: Any]
                    else {
                        print("JSON Serialization Error!")
                        return
                }
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = name + "오늘의 한 줄을 보여주세요"
                            self.performSegue(withIdentifier: "toGoNote", sender: self)
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            self.labelStatus.text = errMessage  }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
