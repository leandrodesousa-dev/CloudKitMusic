import UIKit
import AVFoundation

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {

        //stack view que fica os buttons
        var stackView: UIStackView!
        //botão de gravação
        var recordButton: UIButton!
        //botao de play
        var playButton: UIButton!
        //ativa e rastrear a gravaçao de som como um todo
        var recordingSession: AVAudioSession!
        //rastrea uma gravação individual
        var whistleRecorder: AVAudioRecorder! = nil
        //armeza o reprodutor de audio
        var whistlePlayer: AVAudioPlayer!
        
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
    
        override func viewDidLoad() {
        super.viewDidLoad()

        backButton()
        permissionUserRecorder()

        }

        }
