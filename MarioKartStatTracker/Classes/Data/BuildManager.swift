//
//  BuildPart.swift
//  MarioKartStatTracker
//
//  Created by Justyn Jones on 10/22/22.
//

import Foundation

struct BuildPart: Codable {
	var name: String = ""
	var weight: Int = 0
	var acceleration: Int = 0
	var on_road_traction: Int = 0
	var off_road_traction: Int = 0
	var mini_turbo: Int = 0
	var ground_speed: Int = 0
	var water_speed: Int = 0
	var anti_gravity_speed: Int = 0
	var air_speed: Int = 0
	var ground_handling: Int = 0
	var water_handling: Int = 0
	var anti_gravity_handling: Int = 0
	var air_handling: Int = 0
}

class BuildManager {
	static let shared = BuildManager()
	
	var characterList: [BuildPart] = []
	var kartsList: [BuildPart] = []
	var tiresList: [BuildPart] = []
	var glidersList: [BuildPart] = []
	
	private init() {
		DispatchQueue.global().async {
			self.characterList = self.loadFile(fileName: "characters")
			self.kartsList = self.loadFile(fileName: "karts")
			self.tiresList = self.loadFile(fileName: "tires")
			self.glidersList = self.loadFile(fileName: "gliders")
		}
	}
	
	func loadFile(fileName: String) -> [BuildPart] {
		do {
			if let filePath = Bundle.main.path(forResource: fileName, ofType: "json") {
				let fileURL = URL(fileURLWithPath: filePath)
				let data = try Data(contentsOf: fileURL)
				let decodedData = try JSONDecoder().decode([BuildPart].self, from: data)
				return decodedData
			} else {
				print("File not found")
			}
		} catch {
			print("error somewhere: \(error)")
		}
		
		return []
	}
}
