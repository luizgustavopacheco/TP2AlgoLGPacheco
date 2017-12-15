
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //--------------------------------connection champ e tableview

    @IBOutlet weak var student_name_field: UITextField!
    @IBOutlet weak var student_name_tableview: UITableView!
    
    //--------------------------------les types des pseudonymes creés
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    //--------------------------------
    let userDefautsObj = UserDefaultsManager()//--la classe déjà prêt utilisée ici
    var studentGrades: [studentName: [course: grade]]!
    //--------------------------------lorsque le document est prêt
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
    }
    //--------------------------------les fonction pour faire marcher la tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentGrades.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = [studentName](studentGrades.keys)[indexPath.row]
        return cell
    }
   //-------------------------------- pour supprimer le row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let name = [studentName](studentGrades.keys)[indexPath.row]
            studentGrades[name] = nil
             userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //-------------------------------- garder en mémoire le nom et montrer sur label d'autre interface
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGrades.keys)[indexPath.row]
        userDefautsObj.setKey(theValue: name as AnyObject, theKey: "name")
        performSegue(withIdentifier: "seg", sender: nil)
    }
     //--------------------------------apparaitre et dispparaitre le clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //--------------------------------connection bouton

    @IBAction func addStudent(_ sender: UIButton) {
        if student_name_field.text != "" {
            studentGrades[student_name_field.text!] = [course: grade]()
            student_name_field.text = ""
            userDefautsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            student_name_tableview.reloadData()
        }
    }
   
    //--------------------------------garder en mémoire studentGrades
    func loadUserDefaults(){
        if userDefautsObj.doesKeyExist(theKey: "grades"){
            studentGrades = userDefautsObj.getValue(theKey: "grades") as!
                [studentName: [course: grade]]
        } else {
            studentGrades = [studentName: [course: grade]]()
        }
    }
    
    //--------------------------------
}


