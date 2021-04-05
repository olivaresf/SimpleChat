//
//  PermissionRequestable.swift
//  SimpleChat
//
//  Created by Erik Lopez on 2021/02/16.
//

import Foundation

enum PermissionState {
    case unknown
    case allowed
    case denied
    
    init(userResponse: Bool?) {
        
        guard let granted = userResponse else {
            self = .unknown
            return
        }
        
        self = granted ? .allowed : .denied
    }
}

protocol PermissionRequestable {
    
    var isPermissionRequested: Bool { get }
    var isPermissionGranted: PermissionState { get }
    
    func requestPermission(completionHandler: @escaping (Bool, Error?) -> Void)
}
