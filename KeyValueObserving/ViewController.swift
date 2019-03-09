//
//  ViewController.swift
//  KeyValueObserving
//
//  Created by Britney Smith on 3/2/19.
//  Copyright © 2019 Britney Smith. All rights reserved.
//
//  Key Value Observation: Reactive programming without dependencies!
//
//  KVO - property change observation + reacting to changes with certain behaviors
//
//  Why learn this when we have RxSwift, ReactiveSwift, etc
//  - Helps to get the "big picture" of the purpose of reactive programming in general
//
//  Why not just use this all the time?
//  - Disadvantages:
//  Observable types need to be able to be represented in Objective-C, which is not always possible or desired
//      - Example: Swift enums can only be observed using the string raw value
//  Swift Structs are not observable, since structs cannot inherit from 'NSObject' + @objc can only be used on class members
//      - Usually not a concern if you need the object to be a class since it's a reference type, but some folks
//      still prefer structs 🤷🏾‍♀️ (I like structs)
//


import UIKit

enum Property {
    case name
    case age
}
// Observable class must inherit from 'NSObject' + its properties must be exposed to Objective-C with @objc decorator
class User: NSObject {
    // Two ways to do declare class properties to be observable:
    
    // declare the property `dynamic`
    @objc dynamic var name = String()
    
    // set `willSet` and `didSet` with keyPaths (two ways to do that, too!)
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
    @IBOutlet weak var updateNameButton: UIButton! {
        didSet { updateNameButton.layer.cornerRadius = 25 }
    }
    @IBOutlet weak var updateAgeButton: UIButton! {
        didSet { updateAgeButton.layer.cornerRadius = 25 }
    }
    
    
    // Expose object to Objective-C with @objc decorator
    @objc let user = User()
    // Example of property observation in 'UIViewController', which inherits from 'NSObject' via 'UIResponder'
    @objc dynamic var inputText: String?
    
    // Declare observation token of type 'NSKeyValueObservation'
    var inputTextObservationToken: NSKeyValueObservation?
    var nameObservationToken: NSKeyValueObservation?
    var ageObservationToken: NSKeyValueObservation?
    
    var nameIndexCount = 0
    var ageIndexCount = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign observers to observation token, observe and react to property changes through changeHandler
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
        
        // Invalidate observation tokens to stop observing
        inputTextObservationToken?.invalidate()
        nameObservationToken?.invalidate()
        ageObservationToken?.invalidate()
    }

    private func populateLabel(with array: [Any], indexCount: inout Int, propertyName: Property) {
        switch propertyName {
        case .name:
            user.name = (array[indexCount] as? String)!
        case .age:
            user.age = (array[indexCount] as? Int)!
        }
        
        if indexCount < array.count - 1 {
            indexCount += 1
        } else {
            indexCount = 0
        }
    }

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        inputText = inputTextField.text
    }
    
    @IBAction func updateNameButtonIsTapped(_ sender: UIButton) {
        let nameArray = ["Maria", "Jade", "Christina", "Ash"]
        populateLabel(with: nameArray, indexCount: &nameIndexCount, propertyName: .name)
    }
    
    @IBAction func updateAgeButtonIsTapped(_ sender: UIButton) {
        let ageArray = [36, 27, 52, 48]
        populateLabel(with: ageArray, indexCount: &ageIndexCount, propertyName: .age)
    }
}

