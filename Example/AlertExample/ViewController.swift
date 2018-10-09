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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func successTapped(_ sender: Any) {
        self.showFor(style: Alert.Style.success, message: "İşleminiz başarıyla gerçekleştirildi.")
    }
    
    @IBAction private func warningTapped(_ sender: Any) {
        self.showFor(style: Alert.Style.warning, message: "İşleminiz gerçekleştirilirken bir hata ile karşılaşıldı. Lütfen tekrar deneyiniz.")
    }
    
    @IBAction private func errorTapped(_ sender: Any) {
        self.showFor(style: Alert.Style.error, message: "Ops! Something went terribly wrong while executing your request.")
    }
    
    
    private func showFor(style:Alert.Style, message:String){
        let alert = Alert.init(style: style, message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
}

