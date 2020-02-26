//
//  ViewModelOwning.swift
//  AuthModule
//
//  Created by Максим Стегниенко on 25.02.2020.
//

import Foundation

/// Basic protocol any views with `ViewModel` should be conformed
public protocol ViewModelConfigurable {
    /// Dasta model, closing to UI instances. See `ViewModel` declaration.
    associatedtype ViewModel
  
    /// Strong reference to `ViewModel` instance
    @discardableResult
    func configure(with model: ViewModel) -> Self
}

public protocol ViewModelOwning: ViewModelConfigurable {
    /// Strong reference to `ViewModel` instance
    var viewModel: ViewModel? { get }
}

public extension ViewModelOwning {
    var currentViewModel: ViewModel {
        guard let viewModel = viewModel else {
            fatalError("ViewModel should be set before any operation")
        }
        return viewModel
    }
}
