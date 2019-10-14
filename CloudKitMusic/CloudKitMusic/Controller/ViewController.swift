
import UIKit

class ViewController: UIViewController {

    static var isDirty = true
    
    //metódo que chama outra tela de gravacao
    @objc func addWhistle() {
           let recordController = RecordWhistleViewController()
           navigationController?.pushViewController(recordController, animated: true)
       }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBackWistle()
        
    }
}

