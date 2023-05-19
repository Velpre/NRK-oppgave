//
//  LoadingSpinnerViewController.swift
//  NRK-oppgave
//
//  Created by VP on 20/05/2023.
//

import Foundation
import UIKit

class LoadingSpinnerViewController: UIViewController {
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.color = .white
        view.addSubview(spinner)
        //Centering
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
