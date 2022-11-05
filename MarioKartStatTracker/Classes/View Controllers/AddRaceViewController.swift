//
//  AddRaceViewController.swift
//  MarioKartStatTracker
//
//  Created by Justyn Jones on 11/1/22.
//

import UIKit

class AddRaceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var courseButton: UIButton!
	@IBOutlet weak var ccButton: UIButton!
	@IBOutlet weak var characterButton: UIButton!
	@IBOutlet weak var kartButton: UIButton!
	@IBOutlet weak var finishPlaceTextField: UITextField!
	@IBOutlet weak var totalPlayerTextField: UITextField!
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var saveButton: UIButton!
	
	var currentlySelectedButtonForPicker: UIButton?
	
	var courseList: [String] = ["Select..."]
	var ccList: [String] = ["Select...", "50", "100", "150", "Mirror", "200"]
	var characterList: [String] = ["Select..."]
	var kartList: [String] = ["Select..."]
	
	var currentPickerSource: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Looks for single or multiple taps.
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
		
		//Uncomment the line below if you want the tap not interfere and cancel other interactions.
		tap.cancelsTouchesInView = false
		
		view.addGestureRecognizer(tap)
		
		for character in BuildManager.shared.characterList {
			characterList.append(character.name)
		}
		
		courseButton.setTitle(courseList[0], for: UIControl.State.normal)
		ccButton.setTitle(ccList[0], for: UIControl.State.normal)
		characterButton.setTitle(characterList[0], for: UIControl.State.normal)
		kartButton.setTitle(kartList[0], for: UIControl.State.normal)
	}
	
	//Calls this function when the tap is recognized.
	@objc func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}

	@IBAction func onCourseButtonTapped(_ sender: Any) {
		setPickerViewIsHidden(isHidden: false)
		
		currentlySelectedButtonForPicker = courseButton
		currentPickerSource = courseList
		pickerView.reloadAllComponents()
	}
	
	@IBAction func onCCButtonTapped(_ sender: Any) {
		setPickerViewIsHidden(isHidden: false)
		
		currentlySelectedButtonForPicker = ccButton
		currentPickerSource = ccList
		pickerView.reloadAllComponents()
	}
	
	@IBAction func onCharacterButtonTapped(_ sender: Any) {
		setPickerViewIsHidden(isHidden: false)
		
		currentlySelectedButtonForPicker = characterButton
		currentPickerSource = characterList
		pickerView.reloadAllComponents()
	}
	
	@IBAction func onKartButtonTapped(_ sender: Any) {
		setPickerViewIsHidden(isHidden: false)
		
		currentlySelectedButtonForPicker = kartButton
		currentPickerSource = kartList
		pickerView.reloadAllComponents()
	}
	
	@IBAction func onPickerDoneButtonTapped(_ sender: Any) {
		setPickerViewIsHidden(isHidden: true)
		
		let selectedName = pickerView.delegate?.pickerView?(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)
		currentlySelectedButtonForPicker?.setTitle(selectedName, for: UIControl.State.normal)
	}
	
	@IBAction func onSaveButtonTapped(_ sender: Any) {
	}
	
	func setPickerViewIsHidden(isHidden: Bool) {
		self.toolbar.isHidden = isHidden
		self.pickerView.isHidden = isHidden
		self.saveButton.isHidden = !isHidden
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
}
