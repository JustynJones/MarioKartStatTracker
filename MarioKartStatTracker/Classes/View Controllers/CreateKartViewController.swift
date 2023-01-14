//
//  CreateKartViewController.swift
//  MarioKartStatTracker
//
//  Created by Justyn Jones on 11/1/22.
//

import UIKit

enum KartPiece {
	case character
	case body
	case tires
	case glider
}

class CreateKartViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var kartPieceSegmentedControl: UISegmentedControl!
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var selectedCharacterLabel: UILabel!
	@IBOutlet weak var selectedKartBodyLabel: UILabel!
	@IBOutlet weak var selectedTiresLabel: UILabel!
	@IBOutlet weak var selectedGliderLabel: UILabel!
	@IBOutlet weak var saveButton: UIButton!
	
	var characterList: [String] = ["Select..."]
	var bodyList: [String] = ["Select..."]
	var tiresList: [String] = ["Select..."]
	var gliderList: [String] = ["Select..."]
	
	var currentlySelectedPiece: KartPiece = .character
	var currentPickerSource: [String] = []
	
	var currentlySelectedCharacterIndex: Int = 0
	var currentlySelectedBodyIndex: Int = 0
	var currentlySelectedTiresIndex: Int = 0
	var currentlySelectedGliderIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.nameTextField.delegate = self
		
		for character in BuildManager.shared.characterList {
			characterList.append(character.name)
		}
		
		for kart in BuildManager.shared.kartsList {
			bodyList.append(kart.name)
		}
		
		for tires in BuildManager.shared.tiresList {
			tiresList.append(tires.name)
		}
		
		for glider in BuildManager.shared.glidersList {
			gliderList.append(glider.name)
		}
		
		currentPickerSource = characterList
		pickerView.reloadAllComponents()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	@IBAction func onPartChanged(_ sender: Any) {
		switch kartPieceSegmentedControl.selectedSegmentIndex {
		case 0:
			currentlySelectedPiece = .character
			currentPickerSource = characterList
			pickerView.selectRow(currentlySelectedCharacterIndex, inComponent: 0, animated: false)
			break
		case 1:
			currentlySelectedPiece = .body
			currentPickerSource = bodyList
			pickerView.selectRow(currentlySelectedBodyIndex, inComponent: 0, animated: false)
			break
		case 2:
			currentlySelectedPiece = .tires
			currentPickerSource = tiresList
			pickerView.selectRow(currentlySelectedTiresIndex, inComponent: 0, animated: false)
			break
		case 3:
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
		case .character:
			selectedCharacterLabel.text = "Character: " + partName
			currentlySelectedCharacterIndex = row
		case .body:
			selectedKartBodyLabel.text = "Body: " + partName
			currentlySelectedBodyIndex = row
			break
		case .tires:
			selectedTiresLabel.text = "Tires: " + partName
			currentlySelectedTiresIndex = row
			break
		case .glider:
			selectedGliderLabel.text = "Glider: " + partName
			currentlySelectedGliderIndex = row
			break
		}
	}

	@IBAction func saveButtonTapped(_ sender: Any) {
		var alertTitle = ""
		var alertMessage = ""
		var shouldShowFailureAlert = false
		
		let name = self.nameTextField.text
		if(name == nil || name!.isEmpty) {
			alertTitle = "No Name"
			alertMessage = "The name field is empty. Please give this build a name."
			shouldShowFailureAlert = true
		} else if(self.currentlySelectedCharacterIndex == 0) {
			alertTitle = "No Character Selected"
			alertMessage = "The character field has not been selected. Please select a character."
			shouldShowFailureAlert = true
		} else if(self.currentlySelectedBodyIndex == 0) {
			alertTitle = "No Body Selected"
			alertMessage = "The body field has not been selected. Please select a body."
			shouldShowFailureAlert = true
		} else if(self.currentlySelectedTiresIndex == 0) {
			alertTitle = "No Tires Selected"
			alertMessage = "The tires field has not been selected. Please select some tires."
			shouldShowFailureAlert = true
		} else if(self.currentlySelectedGliderIndex == 0) {
			alertTitle = "No Glider Selected"
			alertMessage = "The glider field has not been selected. Please select a glider."
			shouldShowFailureAlert = true
		}
		
		if(!shouldShowFailureAlert) {
			let kart = Kart(context: self.context)
			kart.name = name
			kart.character = self.characterList[self.currentlySelectedCharacterIndex]
			kart.body = self.bodyList[self.currentlySelectedBodyIndex]
			kart.tires = self.tiresList[self.currentlySelectedTiresIndex]
			kart.glider = self.gliderList[self.currentlySelectedGliderIndex]
			
			do {
				try self.context.save()
				alertTitle = "Save Success"
				alertMessage = "Your build has successfully been saved."
			} catch {
				alertTitle = "Save Failed"
				alertMessage = "Your build has failed to save. Please try again."
			}
		}
		
		let alert = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
		self.present(alert, animated: true, completion: nil)
	}
}

