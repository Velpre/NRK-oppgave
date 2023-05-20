//
//  ViewController.swift
//  NRK-oppgave
//
//  Created by VP on 19/05/2023.
//

import UIKit

class AgeViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var watchButton: UIButton!
    
    let ageDataModel = AgeDataModel()
    var selectedAge:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        //Hidding button until user has choosen age
        watchButton.isHidden = true
        watchButton.layer.cornerRadius = 15
        
    }

    //Sending user to next page and sending age of the user value to the next controller
    @IBAction func startPressed(_ sender: UIButton) {
        let programVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProgramCollectionViewController") as! ProgramCollectionViewController
        programVC.userAge = selectedAge
        //Pushing controller to navigation stack
        navigationController?.pushViewController(programVC, animated: true)
         
    }
}

extension AgeViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageDataModel.ageNumberArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        ageDataModel.ageNumberArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Unhiding button after user choose age
        watchButton.isHidden = false
        selectedAge = ageDataModel.ageNumberArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = ageDataModel.ageNumberArray[row]
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white // Set the desired color for the options
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
}

