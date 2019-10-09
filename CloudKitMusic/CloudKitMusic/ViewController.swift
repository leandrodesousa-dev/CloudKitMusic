
import UIKit

class ViewController: UIViewController {

    fileprivate func buttonBackWistle() {
        //criação de botao da pagina incial para gravar e voltar ao home
        title = "Página inicial"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }
    
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

