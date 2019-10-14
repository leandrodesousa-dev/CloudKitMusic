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
    
        override func viewDidLoad() {
        super.viewDidLoad()

        backButton()
        permissionUserRecorder()
        }

        }
