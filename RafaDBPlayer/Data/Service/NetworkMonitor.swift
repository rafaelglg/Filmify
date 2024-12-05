//
//  NetworkMonitor.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 5/12/24.
//

import Foundation
import Network

@Observable @MainActor
final class NetworkMonitor {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected: Bool = false
    
    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            
            Task { @MainActor [isConnected] in
                self?.isConnected = isConnected
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
