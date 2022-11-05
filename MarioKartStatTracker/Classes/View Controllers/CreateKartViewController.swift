//
//  CreateKartViewController.swift
//  MarioKartStatTracker
//
//  Created by Justyn Jones on 11/1/22.
//

import UIKit

enum KartPiece {
	case body
	case wheels
	case glider
}

class CreateKartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var kartPieceSegmentedControl: UISegmentedControl!
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var selectedKartBodyLabel: UILabel!
	@IBOutlet weak var selectedWheelsLabel: UILabel!
	@IBOutlet weak var selectedGliderLabel: UILabel!
	@IBOutlet weak var saveButton: UIButton!
	
	var kartList: [String] = ["Select..."]
	var wheelsList: [String] = ["Select..."]
	var gliderList: [String] = ["Select..."]
	
	var currentlySelectedPiece: KartPiece = .body
	var currentPickerSource: [String] = []
	
	var currentlySelectedBodyIndex: Int = 0
	var currentlySelectedWheelsIndex: Int = 0
	var currentlySelectedGliderIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for kart in BuildManager.shared.kartsList {
			kartList.append(kart.name)
		}
		
		for wheels in BuildManager.shared.wheelsList {
			wheelsList.append(wheels.name)
		}
		
		for glider in BuildManager.shared.glidersList {
			gliderList.append(glider.name)
		}
		
		currentPickerSource = kartList
		pickerView.reloadAllComponents()
	}
	
	@IBAction func onPartChanged(_ sender: Any) {
		switch kartPieceSegmentedControl.selectedSegmentIndex {
		case 0:
			currentlySelectedPiece = .body
			currentPickerSource = kartList
			pickerView.selectRow(currentlySelectedBodyIndex, inComponent: 0, animated: false)
			break
		case 1:
			currentlySelectedPiece = .wheels
			currentPickerSource = wheelsList
			pickerView.selectRow(currentlySelectedWheelsIndex, inComponent: 0, animated: false)
			break
		case 2:
			currentlySelectedPiece = .glider
			currentPickerSource = gliderList
			pickerView.selectRow(currentlySelectedGliderIndex, inComponent: 0, animated: false)
			break
		default:
			NSLog("Something went very wrong")
			break
		}
		pickerView.reloadAllComponents()
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currentPickerSource.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currentPickerSource[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		var partName = currentPickerSource[row];
		if(row == 0) {
			partName = ""
		}
		
		switch currentlySelectedPiece {
		case .body:
			selectedKartBodyLabel.text = "Body: " + partName
			currentlySelectedBodyIndex = row
			break
		case .wheels:
			selectedWheelsLabel.text = "Wheels: " + partName
			currentlySelectedWheelsIndex = row
			break
		case .glider:
			selectedGliderLabel.text = "Glider: " + partName
			currentlySelectedGliderIndex = row
			break
		}
	}

	@IBAction func saveButtonTapped(_ sender: Any) {
	}
}

