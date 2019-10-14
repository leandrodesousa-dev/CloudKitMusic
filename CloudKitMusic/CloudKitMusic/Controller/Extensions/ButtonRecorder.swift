import UIKit
import AVFoundation

extension RecordWhistleViewController {
    
        //serve para mudar para tela de escolher qual genero que queremos
        @objc func nextTapped(){
            let selectGenre = SelectGenreViewController()
            navigationController?.pushViewController(selectGenre, animated: true)
          //  show(selectGenre, sender: self)
            print("nao entra")
        }

        //serve para regravar o audio, e fazer a animação do button play
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
          title = "Record your whistle"
          navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)
          }
        
        //configurando o botao play
         internal func playButtonSetup(){
             
             playButton = UIButton()
             playButton.translatesAutoresizingMaskIntoConstraints = false
             playButton.setTitle("Tap to play", for: .normal)
             playButton.isHidden = true
             //estou dizendo "não o mostre ao usuário e não deixe que ele ocupe espaço na exibição da pilha"
             playButton.alpha = 0
             playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
             playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
             stackView.addArrangedSubview(playButton)
             
         }
         
         @objc func playTapped(){
             let audioURL = RecordWhistleViewController.getWhistleUrl()
             
             do{
                 whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
                 whistlePlayer.play()
             } catch {
                 let erroAlert = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
                 erroAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                 present(erroAlert, animated: true)
             }
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
