//
//  ViewController.swift
//  AlertExample
//
//  Created by Mahmut Pınarbaşı on 6.10.2018.
//  Copyright © 2018 Mahmut Pınarbaşı. All rights reserved.
//

import UIKit
import Alerty

class ViewController: UIViewController {
    @IBOutlet weak var axisSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.axisValueChanged(self.axisSegmentControl)
    }

    @IBAction private func successTapped(_ sender: Any) {
        let alert = Alert(style: .success, message: "Well well well, You brake the ice!")
        alert.add(buttonWith: "ANOTHER CHALLANGE") { button in
            print("another challange is tapped")
        }
        self.present(alert, animated: true, completion: nil)
        alert.onDismiss = {
            let alert = Alert.init(style: Alert.Style.warning, message: "You've tried to present another alert on onDismiss.")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction private func warningTapped(_ sender: Any) {
        self.showFor(style: Alert.Style.warning, message: "Hmm. We'll definetely look into it.")
    }
    
    @IBAction private func errorTapped(_ sender: Any) {
        let alert = Alert(style: .error, message: "Ops! Something went terribly wrong while executing your request. We think it's a temporary. You can tap TRY AGAIN to re-execute this request")
        alert.add(buttonWith: "TRY AGAIN") { button in
            print("try again is tapped")
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func infoTapped(_ sender: UIButton) {
        self.showFor(style: Alert.Style.info, message: "Yay! You've done it!.")
    }
    
    @IBAction private func axisValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Alert.Attributes.buttonAxis = NSLayoutConstraint.Axis.vertical
            break
        case 1:
            Alert.Attributes.buttonAxis = NSLayoutConstraint.Axis.horizontal
            break
        default:
            Alert.Attributes.buttonAxis = NSLayoutConstraint.Axis.vertical
            break
        }
    }
    
    private func showFor(style:Alert.Style, message:String){
        let alert = Alert.init(style: style, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
}

