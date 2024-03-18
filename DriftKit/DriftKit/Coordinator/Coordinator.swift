//
//  Coordinator.swift
//  DriftKit
//
//  Created by batuhan on 27.12.2023.
//

import Foundation
import UIKit

protocol Coordinator : AnyObject {
    var childCoordinators:[Coordinator] {get}
    func start()
}
