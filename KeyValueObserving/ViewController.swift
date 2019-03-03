//
//  ViewController.swift
//  KeyValueObserving
//
//  Created by Britney Smith on 3/2/19.
//  Copyright © 2019 Britney Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputTextLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    
    
    @objc dynamic var inputText: String?
    var inputTextObservationToken: NSKeyValueObservation?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextObservationToken = observe(\ViewController.inputText, options: [.new], changeHandler: { (vc, change) in
            guard let updatedText = change.newValue as? String else { return }
            vc.inputTextLabel.text = updatedText
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        inputTextObservationToken?.invalidate()
    }


    @IBAction func textFieldDidChange(_ sender: UITextField) {
        inputText = inputTextField.text
    }
    
    @IBAction func updateNameButtonIsTapped(_ sender: UIButton) {
    }
    
    @IBAction func updateAgeButtonIsTapped(_ sender: UIButton) {
    }
}

