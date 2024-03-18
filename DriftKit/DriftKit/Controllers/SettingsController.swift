//
//  SettingsController.swift
//  DriftKit
//
//  Created by batuhan on 21.12.2023.
//

import UIKit

struct SettingsCellModel{
    let title : String
    let handler : ()->()
}

class SettingsController: UIViewController {

    var section = [SettingsCellModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        // Do any additional setup after loading the view.
    }

    

}
