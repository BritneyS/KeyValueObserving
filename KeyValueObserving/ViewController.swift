//
//  ViewController.swift
//  KeyValueObserving
//
//  Created by Britney Smith on 3/2/19.
//  Copyright © 2019 Britney Smith. All rights reserved.
//

import UIKit

class User: NSObject {
    @objc dynamic var name = String()
    @objc var age = 0 {
        willSet{ willChangeValue(forKey: #keyPath(age)) }
        didSet{ didChangeValue(for: \User.age) }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @objc let user = User()
    @objc dynamic var inputText: String?
    var inputTextObservationToken: NSKeyValueObservation?
    var nameObservationToken: NSKeyValueObservation?
    var ageObservationToken: NSKeyValueObservation?
    var nameIndexCount = 0
    var ageIndexCount = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextObservationToken = observe(\.inputText, options: [.new], changeHandler: { (vc, change) in
            guard let updatedText = change.newValue as? String else { return }
            vc.inputTextLabel.text = updatedText
        })
        
        nameObservationToken = observe(\.user.name, options: [.new], changeHandler: { (vc, change) in
            guard let updatedNameText = change.newValue else { return }
            vc.nameLabel.text = updatedNameText
        })
        
        ageObservationToken = observe(\.user.age, options: [.new], changeHandler: { (vc, change) in
            guard let updatedAgeInt = change.newValue else { return }
            vc.ageLabel.text = String(describing: updatedAgeInt)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        inputTextObservationToken?.invalidate()
        nameObservationToken?.invalidate()
        ageObservationToken?.invalidate()
    }


    @IBAction func textFieldDidChange(_ sender: UITextField) {
        inputText = inputTextField.text
    }
    
    @IBAction func updateNameButtonIsTapped(_ sender: UIButton) {
        let nameArray = ["Maria", "Jade", "Christina", "Ash"]
            user.name = nameArray[nameIndexCount]
        if nameIndexCount < nameArray.count - 1 {
            nameIndexCount += 1
        } else {
            nameIndexCount = 0
        }
    }
    
    @IBAction func updateAgeButtonIsTapped(_ sender: UIButton) {
        let ageArray = [36, 27, 52, 48]
        user.age = ageArray[ageIndexCount]
        if ageIndexCount < ageArray.count - 1 {
            ageIndexCount += 1
        } else {
            ageIndexCount = 0
        }
    }
}

