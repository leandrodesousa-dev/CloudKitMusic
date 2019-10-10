import UIKit

extension RecordWhistleViewController {
    
        @objc func nextTapped(){

        }

       @objc func recordTapped(){
       if whistleRecorder == nil{
       startRecoding()
        if !playButton.isHidden {
            UIView.animate(withDuration: 0.35) {
                [unowned self] in
                self.playButton.isHidden = true
                self.playButton.alpha = 0
            }
        }
       } else {
       finishRecording(success: true)
       }
       }

       internal func backButton() {
          //criacao do botao para voltar a tela de gravacao
          title = "Record yout whistle"
          navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
          }

}

extension ViewController {
    internal func buttonBackWistle() {
        //criação de botao da pagina incial para gravar e voltar ao home
        title = "Página inicial"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
    }

}
