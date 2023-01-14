//
//  StatsViewController.swift
//  MarioKartStatTracker
//
//  Created by Justyn Jones on 11/1/22.
//

import UIKit

struct CourseStat {
	var course: Course? = nil
	var wins: Int = 0
	var totalRaces: Int = 0
}

class StatsViewController: UIViewController {
	static let MAX_LATEST_RACES: Int = 10
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	@IBOutlet weak var latestRacesStackView: UIStackView!
	@IBOutlet weak var courseStatsStackView: UIStackView!
	var savedRaces: [Race] = []
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		clearStackViewSubviews(stackView: latestRacesStackView)
		clearStackViewSubviews(stackView: courseStatsStackView)
		fetchRaces()
		
		if savedRaces.count != 0 {
			var courseStats: [String: CourseStat] = [:]
			
			for course in CourseManager.shared.courseList {
				courseStats.updateValue(CourseStat(course: course, wins: 0, totalRaces: 0), forKey: course.name)
			}
			
			for index in 0...(savedRaces.count - 1) {
				let race = savedRaces[index]
				let win = (Double(race.place) / Double(race.totalPlayers)) <= 0.5
				if(index < StatsViewController.MAX_LATEST_RACES) {
					let label = UILabel()
					label.text = String(format: "You placed %d out of %d on %@ at %@ using %@", race.place, race.totalPlayers, race.course!, race.cc!, race.kart!)
					label.lineBreakMode = NSLineBreakMode.byWordWrapping
					label.numberOfLines = 0
					label.textAlignment = NSTextAlignment.center
					if(win) {
						label.backgroundColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.4)
					} else {
						label.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.4)
					}
					latestRacesStackView.addArrangedSubview(label)
				}
				
				var courseStat = courseStats[race.course!]
				courseStat!.totalRaces += 1
				courseStat!.wins += win ? 1 : 0
				courseStats.updateValue(courseStat!, forKey: race.course!)
			}
			
			for key in courseStats.keys {
				let courseStat = courseStats[key]
				let label = UILabel()
				label.lineBreakMode = NSLineBreakMode.byWordWrapping
				label.numberOfLines = 0
				label.textAlignment = NSTextAlignment.center
				
				if courseStat?.totalRaces == 0 {
					label.text = String(format: "No races found for %@", key)
				} else {
					let totalRaces = courseStat!.totalRaces
					let winRate = Int((Double(courseStat!.wins) / Double(totalRaces)) * 100)
					label.text = String(format: "%@: Win Rate: %d%%\nTotal Races: %d", key, winRate, totalRaces)
					if(winRate >= 50) {
						label.backgroundColor = UIColor.init(red: 0, green: 1, blue: 0, alpha: 0.4)
					} else {
						label.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.4)
					}
				}
				
				courseStatsStackView.addArrangedSubview(label)
			}
		}
	}
	
	func clearStackViewSubviews(stackView: UIStackView) {
		for subview in stackView.subviews {
			stackView.removeArrangedSubview(subview)
			subview.removeFromSuperview()
		}
	}
	
	func fetchRaces() {
		savedRaces = try! self.context.fetch(Race.fetchRequest()).reversed()
	}
}
