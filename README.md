# KeyValueObserving

**README Last Updated: 3-18-19**

## General Info :clipboard:

This is a demo app to demonstrate KVO within the iOS Cocoa API in Swift.

**Key-Value Observation:** Reactive programming without dependencies!

KVO - property change observation + reacting to changes with certain behaviors

**Why learn this when we have RxSwift, ReactiveSwift, etc?**

Helps to get the "big picture" of the purpose of reactive programming in general  

**Why not just use this all the time?**

Disadvantages:

- Observable types need to be able to be represented in Objective-C, which is not always possible or desired

    Example: Swift enums can only be observed using the string raw value
      
- Swift Structs are not observable, since structs cannot inherit from 'NSObject' + @objc can only be used on class members

    Usually not a concern if you need the object to be a class since it's a reference type, but some folks still prefer structs 🤷🏾‍♀️ (I like structs)
     
## Basics

- Observable class must inherit from 'NSObject' + its properties must be exposed to Objective-C with @objc decorator
- Two ways to do declare class properties to be observable: 1) declare the property `dynamic` OR set `willSet` and `didSet` with keyPaths (two ways to do that, too!)

```swift
class User: NSObject {

    @objc dynamic var name = String()

    @objc var age = 0 {
        willSet{ willChangeValue(forKey: #keyPath(age)) }
        didSet{ didChangeValue(for: \User.age) }
    }
}

//...

class ViewController: UIViewController {
    //...
    @objc dynamic var inputText: String?
    //...
}
```

- Expose object to Objective-C with @objc decorator

```swift
@objc let user = User()
```
- Declare observation token of type 'NSKeyValueObservation'

```swift
var inputTextObservationToken: NSKeyValueObservation?
var nameObservationToken: NSKeyValueObservation?
var ageObservationToken: NSKeyValueObservation?
```
- Assign observers to observation token, observe and react to property changes through changeHandler

```swift
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
```
- Invalidate observation tokens to stop observing

```swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    inputTextObservationToken?.invalidate()
    nameObservationToken?.invalidate()
    ageObservationToken?.invalidate()
}
```

- Results!

![kvo-demo-app](https://user-images.githubusercontent.com/8409475/54553143-f2892e80-4987-11e9-85ce-0e15f7b849f0.gif "KVO Demo App")
     
[See `ViewController.swift` of this project for in-line explanations and all logic!](https://github.com/BritneyS/KeyValueObserving/blob/master/KeyValueObserving/ViewController.swift)

## Required Tools :wrench:

- Swift 4.2
- XCode 10.1

## Credits :clapper:

This project is an elaboration on the tutorial by [Kilo Loco](https://www.youtube.com/channel/UCv75sKQFFIenWHrprnrR9aA) [here](https://www.youtube.com/watch?v=Wu5l4e5uW4w).

## More Info :information_source:

Apple's Docs: [Using Key-Value Observing in Swift](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift)
