//
//  AddRaceViewController.swift
//  MarioKartStatTracker
//
//  Created by Justyn Jones on 11/1/22.
//

import UIKit

class AddRaceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	@IBOutlet weak var kartSelectButton: UIButton!
	@IBOutlet weak var characterLabel: UILabel!
	@IBOutlet weak var kartBodyLabel: UILabel!
	@IBOutlet weak var kartTiresLabel: UILabel!
	@IBOutlet weak var kartGliderLabel: UILabel!
	var currentlySelectedKart: Kart!
	
	@IBOutlet weak var courseButton: UIButton!
	@IBOutlet weak var ccButton: UIButton!
	@IBOutlet weak var finishPlaceTextField: UITextField!
	@IBOutlet weak var totalPlayerTextField: UITextField!
	
	@IBOutlet weak var pickerView: UIPickerView!
	@IBOutlet weak var toolbar: UIToolbar!
	
	@IBOutlet weak var saveButton: UIButton!
	
	var currentlySelectedButtonForPicker: UIButton?
	
	var savedKarts: [Kart] = []
	
	var courseList: [String] = ["Select..."]
	var ccList: [String] = ["Select...", "50", "100", "150", "Mirror", "200"]
	
	var currentPickerSource: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Looks for single or multiple taps.
		let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
		
		//Uncomment the line below if you want the tap not interfere and cancel other interactions.
		tap.cancelsTouchesInView = false
		
		view.addGestureRecognizer(tap)
		
		for course in CourseManager.shared.courseList {
			courseList.append(course.name)
		}
		
		courseButton.setTitle(courseList[0], for: UIControl.State.normal)
		ccButton.setTitle(ccList[0], for: UIControl.State.normal)
		
		kartSelectButton.layer.borderWidth = 1.0
		kartSelectButton.layer.borderColor = UIColor.label.cgColor
		kartSelectButton.layer.cornerRadius = 5.0
		kartSelectButton.clipsToBounds = true
		
		kartSelectButton.showsMenuAsPrimaryAction = true
		kartSelectButton.changesSelectionAsPrimaryAction = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.populateKartsList()
	}
	
	func populateKartsList() {
		let handler = { (action: UIAction) in
			self.onKartSelected(title: action.title)
		}
		
		var kartSelections = [UIAction(title: "Select...", handler: handler)]
		
		savedKarts = try! self.context.fetch(Kart.fetchRequest())
		
		for kart in savedKarts {
			kartSelections.append(UIAction(title: kart.name!, handler: handler))
		}
		
		self.kartSelectButton.menu = UIMenu(children: kartSelections)
	}
	
	func onKartSelected(title: String) {
		var selectedKart: Kart? = nil
		
		for kart in savedKarts {
			if(kart.name == title) {
				selectedKart = kart
				break
			}
		}
		
		if(selectedKart == nil) {
			characterLabel.text = "Select..."
			kartBodyLabel.text = "Select..."
			kartTiresLabel.text = "Select..."
			kartGliderLabel.text = "Select..."
		} else {
			characterLabel.text = selectedKart?.character
			kartBodyLabel.text = selectedKart?.body
			kartTiresLabel.text = selectedKart?.tires
			kartGliderLabel.text = selectedKart?.glider
		}
		
		currentlySelectedKart = selectedKart
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
	
	@IBAction func onPickerDoneButtonTapped(_ sender: Any) {
		setPickerViewIsHidden(isHidden: true)
		
		let selectedName = pickerView.delegate?.pickerView?(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)
		currentlySelectedButtonForPicker?.setTitle(selectedName, for: UIControl.State.normal)
		pickerView.selectRow(0, inComponent: 0, animated: false)
	}
	
	@IBAction func onSaveButtonTapped(_ sender: Any) {
		var alertTitle = ""
		var alertMessage = ""
		var shouldShowFailureAlert = false

		let place = Int(self.finishPlaceTextField.text!) ?? 0
		let totalPlayers = Int(self.totalPlayerTextField.text!) ?? 0

		if(currentlySelectedKart == nil) {
			alertTitle = "No Kart Selected"
			alertMessage = "No kart has been selected. Please select a kart."
			shouldShowFailureAlert = true
		} else if(self.courseButton.titleLabel?.text == self.courseList[0]) {
			alertTitle = "No Course Selected"
			alertMessage = "A course has not been selected. Please select a course."
			shouldShowFailureAlert = true
		} else if(self.ccButton.titleLabel?.text == self.ccList[0]) {
			alertTitle = "No CC Selected"
			alertMessage = "A CC has not been selected. Please select a CC."
			shouldShowFailureAlert = true
		} else if(totalPlayers <= 0 || totalPlayers > 12) {
			alertTitle = "Invalid Total Players"
			alertMessage = "There was an issue with the total number of players. Please submit a vaild total of players"
			shouldShowFailureAlert = true
		} else if(place <= 0 || place > totalPlayers) {
			alertTitle = "Invalid Finish Place"
			alertMessage = "There was an issue with your finish place. Please submit a valid finish place."
			shouldShowFailureAlert = true
		}

		if(!shouldShowFailureAlert) {
			let race = Race(context: self.context)
			race.kart = currentlySelectedKart.name
			race.course = self.courseButton.titleLabel?.text
			race.cc = self.ccButton.titleLabel?.text
			race.place = Int64(place)
			race.totalPlayers = Int64(totalPlayers)

			do {
				try self.context.save()
				alertTitle = "Save Success"
				alertMessage = "Your Race has successfully been saved."

				self.courseButton.setTitle(self.courseList[0], for: UIControl.State.normal)
				self.ccButton.setTitle(self.ccList[0], for: UIControl.State.normal)
				self.finishPlaceTextField.text = ""
				self.totalPlayerTextField.text = ""
			} catch {
				alertTitle = "Save Failed"
				alertMessage = "Your race has failed to save. Please try again."
			}
		}

		let alert = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
		self.present(alert, animated: true, completion: nil)
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
