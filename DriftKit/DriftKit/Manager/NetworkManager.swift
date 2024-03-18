//
//  NetworkManager.swift
//  DriftKit
//
//  Created by batuhan on 22.01.2024.
//

import Foundation
import Network

extension Notification.Name {
    static let networkNotification = Notification.Name(rawValue: "connection")
}


final class NetworkManager {
   
    private init(){  }
    static let shared          = NetworkManager()
    let monitor                = NWPathMonitor()
    private var status         : NWPath.Status   = .requiresConnection
//    var isReachable            : ((Bool) -> Void)?
    
    var isReachableOnCellular : Bool = true
    var notificationCenter    = NotificationCenter.default
    
    func startMonitoring(){
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status                = path.status
            self?.isReachableOnCellular = path.isExpensive
            if self?.status == .satisfied {
//                self?.isReachable?(true)
                self?.notificationCenter.post(name: .networkNotification, object: true)
            }else {
//                self?.isReachable?(false)
                self?.notificationCenter.post(name: .networkNotification, object: false)
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
}
