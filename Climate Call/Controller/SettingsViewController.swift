//
//  SettingsViewController.swift
//  Climate Call
//
//  Created by Nick Dubauskas on 11/6/23.
//

import UIKit
import MessageUI
import UserNotifications

class SettingsViewController: UIViewController{
    
    
    
    @IBOutlet weak var monLabel: UIButton!
    @IBOutlet weak var tuesLabel: UIButton!
    @IBOutlet weak var wedLabel: UIButton!
    @IBOutlet weak var thursLabel: UIButton!
    @IBOutlet weak var friLabel: UIButton!
    @IBOutlet weak var satLabel: UIButton!
    @IBOutlet weak var sunLabel: UIButton!
    @IBOutlet weak var scheduleTextLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var weatherColor: Int = 0
    var selectedDays = [String]()
    var selectedDate = Date()
    private var gradientLayer: CAGradientLayer?
    let weatherVC = WeatherViewController()
    var hexColor: UIColor = .white
    var temp: Double = 0.0
    var lowTemp: Double = 0.0
    var highTemp: Double = 0.0
    var daysDictionary = ["Monday": false, "Tuesday": false, "Wednesday": false, "Thursday": false, "Friday": false, "Saturday": false, "Sunday": false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gradientLayer?.removeFromSuperlayer()
        let newGradientLayer = CAGradientLayer()
        newGradientLayer.colors = [hexColor.cgColor, UIColor.white.cgColor]
        newGradientLayer.locations = [0.0, 1.0]
        newGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        newGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.3)
        newGradientLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(newGradientLayer, at: 0)
        self.gradientLayer = newGradientLayer
        monLabel.layer.cornerRadius = monLabel.frame.size.height / 2
        monLabel.clipsToBounds = true
        tuesLabel.layer.cornerRadius = tuesLabel.frame.size.height / 2
        tuesLabel.clipsToBounds = true
        wedLabel.layer.cornerRadius = wedLabel.frame.size.height / 2
        wedLabel.clipsToBounds = true
        thursLabel.layer.cornerRadius = thursLabel.frame.size.height / 2
        thursLabel.clipsToBounds = true
        friLabel.layer.cornerRadius = friLabel.frame.size.height / 2
        friLabel.clipsToBounds = true
        satLabel.layer.cornerRadius = satLabel.frame.size.height / 2
        satLabel.clipsToBounds = true
        sunLabel.layer.cornerRadius = sunLabel.frame.size.height / 2
        sunLabel.clipsToBounds = true
        scheduleTextLabel.layer.cornerRadius = scheduleTextLabel.frame.size.height / 2
        scheduleTextLabel.clipsToBounds = true
        
        if let savedDays = UserDefaults.standard.dictionary(forKey: "SavedDaysDictionary") as? [String: Bool] {
            daysDictionary = savedDays
        }
        for (day, isSelected) in daysDictionary {
            if let button = view.viewWithTag(tagForDay(day)) as? UIButton {
                button.isSelected = isSelected
                if button.isSelected == true{
                    selectedDays.append(day)
                }
            }
            
        }
        if let savedDate = UserDefaults.standard.object(forKey: "SelectedDateKey") as? Date {
            selectedDate = savedDate
            datePicker.date = selectedDate
            
            let message = "The current temperature is \(temp) with a high of: \(highTemp) and a low of: \(lowTemp)"
            
            scheduleLocalNotifications(selectedDays: selectedDays, selectedTime: selectedDate, message: message)
        }
      
        
        
        if weatherColor == 0xE1DE2A {
            
            
        }
        
        else{
            
        }
     
    }
    override func viewWillDisappear(_ animated: Bool) {
        let message = "The current temperature is \(temp) with a high of: \(highTemp) and a low of: \(lowTemp)"
        scheduleLocalNotifications(selectedDays: selectedDays, selectedTime: selectedDate, message: message)
        print("View going away")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       
       // completionHandler([.alert, .sound, .badge])
        print("in first complettion hander")
        completionHandler([.banner, .list, .sound, .badge])
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("in second complettion hander")
        completionHandler()
    }
    func tagForDay(_ day: String) -> Int {
        switch day {
        case "Monday": return 1
        case "Tuesday": return 2
        case "Wednesday": return 3
        case "Thursday" : return 4
        case "Friday": return 5
        case "Saturday": return 6
        case "Sunday": return 7
        default: return 0
        }
    }


    
    @IBAction func dayButton(_ sender: UIButton){
        
        if let day = sender.currentTitle{
            var value = daysDictionary[day] ?? false
            value.toggle()
            daysDictionary[day] = value
            sender.isSelected = !sender.isSelected
            UserDefaults.standard.set(daysDictionary, forKey: "SavedDaysDictionary")
            
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        selectedDate = datePicker.date
        
        //selectedDate = getLocalTime(selectedDate)
        let message = "The current temperature is \(temp) with a high of: \(highTemp) and a low of: \(lowTemp)"
        
        scheduleLocalNotifications(selectedDays: selectedDays, selectedTime: selectedDate, message: message)
        print("timezoneoffSet \(selectedDate)")
           UserDefaults.standard.set(selectedDate, forKey: "SelectedDateKey")
           print("Selected date at changing value: \(selectedDate)")
    }
    func getLocalTime(_ selectedDate: Date) -> Date{
        
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
         let epochDate = selectedDate.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        
        return timeZoneOffsetDate
    }

    func getUTCTime(_ selectedDate: Date) -> Date{
        
        let calendar = Calendar.current
           let timeZoneOffset = TimeInterval(calendar.timeZone.secondsFromGMT(for: selectedDate))
           let utcDate = selectedDate.addingTimeInterval(-timeZoneOffset)
           return utcDate
    }
    func scheduleLocalNotifications(selectedDays: [String], selectedTime: Date, message: String) {
    
        print("In schedule notifications")
            
            let content = UNMutableNotificationContent()
            content.title = "Daily Weather"
            content.body = message
        
            for day in selectedDays {
                print("Processing day: \(day)")
                
                guard let weekday = DayOfWeek(rawValue: day.lowercased())?.weekday else {
                    print("Invalid day: \(day)")
                    continue
                }
                
                let localTime = getLocalTime(selectedDate)
                var dateComponents = DateComponents()
                dateComponents.weekday = weekday
                dateComponents.hour = Calendar.current.component(.hour, from: selectedTime)
                dateComponents.minute = Calendar.current.component(.minute, from: selectedTime)
                dateComponents.timeZone = TimeZone.current
                print("=====|DATE COMPONENTS|====== \n \(dateComponents)")
                

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                print("Trigger info \(trigger)")
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification for \(day): \(error)")
                    } else {
                        print("Notification scheduled for \(day) at \(selectedTime)")
                        print("Notif for local time for \(day) at \(localTime)")
                    }
                }
            }
    }
    
    enum DayOfWeek: String {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
        
        var weekday: Int {
            switch self {
            case .sunday: return 7
            case .monday: return  1
            case .tuesday: return 2
            case .wednesday: return 3
            case .thursday: return 4
            case .friday: return 5
            case .saturday: return 6
            }
        }
    }



    
}
