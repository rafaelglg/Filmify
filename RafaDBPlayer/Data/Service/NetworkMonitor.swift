//
//  NetworkMonitor.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 5/12/24.
//

import Foundation
import Network

@MainActor
protocol NetworkMonitor {
    var networkMonitor: NWPathMonitor { get }
    var workerQueue: DispatchQueue { get }
    var isConnected: Bool? { get set }
    func getNetwork()
}

@Observable
final class NetworkMonitorImpl: NetworkMonitor {
    let networkMonitor = NWPathMonitor()
    let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected: Bool?
    
    init() {
        getNetwork()
    }
    
    func getNetwork() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            
            Task { @MainActor [isConnected] in
                self?.isConnected = isConnected
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
