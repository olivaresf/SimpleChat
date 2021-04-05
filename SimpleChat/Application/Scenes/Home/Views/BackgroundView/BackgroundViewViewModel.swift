//
//  BackgroundViewViewModel.swift
//  SimpleChat
//
//  Created by Erik Lopez on 2021/02/23.
//

import Foundation

protocol BackgroundViewViewModelDelegate: class {
    func userTappedBackgroundView()
}

struct BackgroundViewViewModel {
    let title: String
    let subtitle: String
    weak var delegate: BackgroundViewViewModelDelegate?
    
    func didReceiveTap() {
        delegate?.userTappedBackgroundView()
    }
}
