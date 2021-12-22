//
//  ViewController.swift
//  Local_Notifications
//
//  Created by Leena 1418 on 21/12/2021.
//

import UIKit

class LocalNotificationsController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var setTimer: UILabel!
    @IBOutlet weak var stopTimer: UIButton!
    @IBOutlet weak var workTime: UILabel!
    
    var pickerData = [5, 10, 20, 30]
    var timerSelected = 5
    var timerStoped = false
    var totalTime_hours = 0
    var totalTime_min = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        // Connect data:
        self.timerPicker.delegate = self
        self.timerPicker.dataSource = self

    }
    
    @IBAction func startTimer(_ sender: UIButton) {
   
        timerStoped = !timerStoped
        if timerStoped {
            stopTimer.backgroundColor = UIColor(named: "red")
            stopTimer.setTitleColor(.white, for: .normal)
            stopTimer.setTitle("Stop Timer", for: .normal)
            setTimer.text = "\(timerSelected) minutes timer set"
            setTimer.textColor = .blue
            getTime()
        }else{
            stopTimer.backgroundColor = .white
            stopTimer.setTitle("Start Timer", for: .normal)
            stopTimer.setTitleColor(UIColor(named: "bg"), for: .normal)
            setTimer.text = "No timer"
            setTimer.textColor = .white
            workTime.text = "Work until 00:00 AM/PM"
            
        }

    }
    func getTime(){
        let date = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var totalMinutes = minutes + timerSelected
        if totalMinutes > 60 {
            hour = hour + 1
            totalMinutes = totalMinutes - 60
        }
      
        if hour < 12{
            if hour == 0{
                hour = 12
            }
            workTime.text = "Work until \(hour):\(totalMinutes) AM"
        }else{
            workTime.text = "Work until \(hour):\(totalMinutes) PM"
        }
        
    }
    
    func someHandler(alert: UIAlertAction!) {
        stopTimer.backgroundColor = .white
        stopTimer.setTitle("Start Timer", for: .normal)
        stopTimer.setTitleColor(UIColor(named: "bg"), for: .normal)
        setTimer.text = "No timer"
        setTimer.textColor = .white
        workTime.text = "Work until 00:00 AM/PM"
    }
    @IBAction func startNewDay(_ sender: UIButton) {
        // create the alert
        let alert = UIAlertController(title: "Are you sure it's a new day?",message: nil, preferredStyle: UIAlertController.Style.alert)

                // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "New Day", style: UIAlertAction.Style.destructive, handler: someHandler))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

                // show the alert
                self.present(alert, animated: true, completion: nil)
    }
    @IBAction func LogPage(_ sender: UIButton) {
    }
    // Number of columns of data
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     // The number of rows of data
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return pickerData.count
     }
     
     // The data to return fopr the row and component (column) that's being passed in
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return "\(pickerData[row]) Minutes"
     }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timerSelected = pickerData[row]
    }
}

