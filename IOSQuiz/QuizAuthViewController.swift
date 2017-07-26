//
//  QuizAuthViewController.swift
//  IOSQuiz
//
//  Created by galushka on 6/2/17.
//  Copyright © 2017 galushka. All rights reserved.
//

import UIKit

struct QuizSignParams {
    let email: String
    let password: String
}


class QuizAuthViewController: UIViewController {

    private let quizAlerts = QuizAlerts()
    private let registrationSuccessedText = "Registration successed. Please Login"
    
    @IBOutlet weak var emailTextField: QuizAuthTextField!
    @IBOutlet weak var passwordTextField: QuizAuthTextField!
    
    @IBOutlet weak var signUpButton: RoundedUIButton!
    @IBOutlet weak var signInButton: RoundedUIButton!
    
    @IBOutlet weak var registrationInformLabel: UILabel!
    @IBOutlet weak var signUpErrorLabel: UILabel!
    
    let quizAuthModule = QuizAuthModule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearSignFields()
        setHardcodedSignParams()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let signParams = getRegistrationParamsFromTextFields() else {return}

        signUp(signParams: signParams)
    }

    @IBAction func signInButtonPressed(_ sender: Any) {
        
        guard let signParams = getRegistrationParamsFromTextFields() else {return}
        
        signIn(signParams: signParams)
    }
    
    func getRegistrationParamsFromTextFields() -> QuizSignParams? {
        guard let email = emailTextField.text else { return nil }
        guard let password = passwordTextField.text else {return nil}
        
        return QuizSignParams(email: email, password: password)
    }
    
    private func registrationSuccessed() {
        registrationInformLabel.text = registrationSuccessedText
        signUpErrorLabel.text = ""
        signUpErrorLabel.isHidden = true
        signUpButton.isHidden = true
        
    }
    
    private func signUpWrong(text: String) {
        signUpErrorLabel.text = text
    }
    
    private func signInWrong(text: String) {
        registrationInformLabel.text = text
    }
    
    private func clearSignFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func setHardcodedSignParams() {
        emailTextField.text = "andrewgalushka@gmail.com"
        passwordTextField.text = "123456789"
    }

    func signUp(signParams: QuizSignParams) {
        
        quizAuthModule.signUp(signParams: signParams) { (result, errorMessage) in
            DispatchQueue.main.async { [weak self] in
                
                if result == .successful {
                    self?.registrationSuccessed()
                    
                } else if result == .wrongSignUp {
                    guard let fetchedErrorMessage = errorMessage else { return }
                    self?.signUpWrong(text: fetchedErrorMessage)
                    
                } else if !result.isResultFromServer() {
                    self?.presentConnetionTroubleAlert(from: result)
                    
                } else if result == .unknownError {
                    print("Unknown Error!!!")
                }
            }
        }
    } // func signUp(signParams: QuizSignParams)
    
    func signIn(signParams: QuizSignParams) {
        
        quizAuthModule.signIn(signParams: signParams) { (result, errorMessage) in
            DispatchQueue.main.async { [weak self] in
                
                if result == .successful {
                    self?.dismiss(animated: true, completion: nil)
                    
                } else if result == .wrongSignIn {
                    guard let fetchedErrorMessage = errorMessage else { return }
                    self?.signInWrong(text: fetchedErrorMessage)
                    
                } else if !result.isResultFromServer() {
                    self?.presentConnetionTroubleAlert(from: result)
                    
                } else if result == .unknownError {
                    print("Unknown Error!!!")
                }
            }
        }
    }
    
    func presentConnetionTroubleAlert(from authModuleResult: QuizAuthModuleResult) {
        if authModuleResult == .notConnetedToInternet {
            quizAlerts.presentNotConnectedToInternet(on: self, alertActionComplition: nil)
        } else if authModuleResult == .cantConnectToServer {
            quizAlerts.presentCantConnectToServer(on: self, alertActionComplition: nil)
        }
    }
}

extension QuizAuthViewController {
    static var storyboardID: String {
        return "QuizAuthViewControllerStroryboardID"
    }
}
