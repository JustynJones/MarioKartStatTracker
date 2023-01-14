//
//  CourseManager.swift
//  MarioKartStatTracker
//
//  Created by Justyn Jones on 12/26/22.
//

import Foundation

struct Course: Codable {
	var name: String = ""
	var cup: String = ""
}

class CourseManager {
	static let shared = CourseManager()
	
	var courseList: [Course] = []
	
	private init() {
		DispatchQueue.global().async {
			do {
			 if let filePath = Bundle.main.path(forResource: "courses", ofType: "json") {
				 let fileURL = URL(fileURLWithPath: filePath)
				 let data = try Data(contentsOf: fileURL)
				 self.courseList = try JSONDecoder().decode([Course].self, from: data)
			 } else {
				 print("File not found")
			 }
		 } catch {
			 print("error somewhere: \(error)")
		 }
		}
	}
}
