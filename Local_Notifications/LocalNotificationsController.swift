import UIKit

class LocalNotificationsController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var setTimer: UILabel!
    @IBOutlet weak var stopTimer: UIButton!
    @IBOutlet weak var workTime: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    var pickerData = [5, 10, 20, 30]
    var timerSelected = 5
    var timerStoped = false
    var totalTime_hours = 0
    var totalTime_min = 0
    var runningNotifications: [LocalNotification] = []
    var currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
   
        // Connect data:
        self.timerPicker.delegate = self
        self.timerPicker.dataSource = self
    }
    func createLocalNotification(time: Int){
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Timer is done!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "You studied \(time) minutes good job!", arguments: nil)
        content.sound = UNNotificationSound.default
        
        
        currentDate = Date(timeIntervalSinceNow: Double(time))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        
        
        let localNotification = LocalNotification(dateItStarted:currentDate,state:"Set \(timerSelected) minutes timer")
        runningNotifications.append(localNotification)
        
        
        
        let dateComponent = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: currentDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: "TimerAlarm", content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
            
        }
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
            setTimer.text = "\(timerSelected) minutes timer cancelled"
            setTimer.textColor = .white
            workTime.text = "Work until 00:00 AM/PM"
            print(UIApplication.shared.scheduledLocalNotifications)
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            currentDate = Date(timeIntervalSinceNow: Double(timerSelected))
            runningNotifications.append(LocalNotification(dateItStarted:currentDate,state:" \(timerSelected) minutes timer cancelled"))

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
        createLocalNotification(time: timerSelected)
       showAlert(title: "\(timerSelected) minutes countdown", message: "After \(timerSelected) minutes, you'll be notified")
    }
    
    func someHandler(alert: UIAlertAction!) {
        stopTimer.backgroundColor = .white
        stopTimer.setTitle("Start Timer", for: .normal)
        stopTimer.setTitleColor(UIColor(named: "bg"), for: .normal)
        setTimer.text = "No timer"
        setTimer.textColor = .white
        workTime.text = "Work until 00:00 AM/PM"
        totalTime.text = "Total time: 0 hours, 0 min"
         timerSelected = 5
         timerStoped = false
         totalTime_hours = 0
         totalTime_min = 0
        runningNotifications.removeAll()
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController

        vc.modalPresentationStyle = .formSheet
        vc.allNotifications = runningNotifications
        self.navigationController?.pushViewController(vc, animated: true)
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
struct LocalNotification{
    var dateItStarted = Date()
    var state: String
}

extension LocalNotificationsController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // notification arrived
        notificationReceive()
        completionHandler(UNNotificationPresentationOptions.sound)
    }
    func notificationReceive(){
        showAlert(title: "Timer is done!", message: "You studied \(timerSelected) minutes good job!")
        totalTime_min = totalTime_min + timerSelected
       if totalTime_min >= 60{
           totalTime_min = totalTime_min - 60
           totalTime_hours = totalTime_hours + 1
       }
       totalTime.text = "Total time: \(totalTime_hours) hours, \(totalTime_min) min"
        stopTimer.backgroundColor = .white
        stopTimer.setTitle("Start Timer", for: .normal)
        stopTimer.setTitleColor(UIColor(named: "bg"), for: .normal)
        timerStoped = !timerStoped
        setTimer.text = "\(timerSelected) minute timer done"
        setTimer.textColor = .white
        workTime.text = "Work until 00:00 AM/PM"
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // notification clicked or opened
        print("did receive notification")
        notificationReceive()
        
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
