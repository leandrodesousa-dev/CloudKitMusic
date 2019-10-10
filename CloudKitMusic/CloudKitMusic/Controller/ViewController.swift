
import UIKit

class ViewController: UIViewController {

    //metódo que chama outra tela
    @objc func addWhistle() {
           let recordController = RecordWhistleViewController()
           navigationController?.pushViewController(recordController, animated: true)
       }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBackWistle()
        
    }
}

