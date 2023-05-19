//
//  ProgramCollectionViewController.swift
//  NRK-oppgave
//
//  Created by VP on 19/05/2023.
//

import UIKit



class ProgramCollectionViewController: UIViewController {
    
    var userAge: String!
    
    var programDataModel = ProgramDataModel()
    let spinnerVC = LoadingSpinnerViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        programDataModel.delegate = self
        addSpinner(to: self, spinner: spinnerVC)
        programDataModel.fetchProgram(age: userAge)
    }
    
}

extension ProgramCollectionViewController: DataManagerDelegate{
    func didUpdateData(_ movie: Movie, _ imageList: [UIImage]) {
        print(movie)
        print("-----------")
        print(imageList)
        self.spinnerVC.view.removeFromSuperview()
    }
    
    func didFoundError(_ error: String) {
        print(error)
    }
}
