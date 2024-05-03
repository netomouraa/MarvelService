//
//  NetworkManager.swift
//  MarvelService
//
//  Created by Neto Moura on 02/05/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import Network

@available(iOS 12.0, *)
class NetworkManager {
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private var isConnected: Bool = false
    
    var isConnectedToInternet: Bool {
        return isConnected
    }
    
    private init() {}
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
