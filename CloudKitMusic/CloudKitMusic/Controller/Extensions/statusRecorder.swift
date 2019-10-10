import UIKit
import AVFoundation

extension RecordWhistleViewController {
    
          internal func startRecoding(){
    //colocando o fundo vermelho para dizer que esta sendo gravado
    view.backgroundColor = UIColor(red: 0.4, green: 0, blue: 0, alpha: 1)

    //muda o titulo do botao para toque para parar
    recordButton.setTitle("Tap to stop", for: .normal)

    //buscar onde foi salvo a gravacao
    let audioURL = RecordWhistleViewController.getWhistleUrl()
    print(audioURL.absoluteURL)

    //criar dicionario para as configuracoes do audio
    let settings = [
    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
    AVSampleRateKey: 1200,
    AVNumberOfChannelsKey: 1,
    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    /*Criei um objeto AVAudioRecorder para direcionar o URL da gravação
    coloquei esse objeto como delegado
    chamei o record desse objeto
    */

    do{
    whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
    //Tem que coloca o protocolo delegate desse método
    whistleRecorder.delegate = self
    whistleRecorder.record()
    } catch {
    finishRecording(success: false)
    }
    }

          internal func finishRecording(success: Bool){

          view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)

          whistleRecorder.stop()
          whistleRecorder = nil
            
            if playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = false
                    self.playButton.alpha = 1
                }
            }

          if success {
          recordButton.setTitle("Tap to re-record", for: .normal)
          navigationItem.backBarButtonItem = UIBarButtonItem(title: "Next", style: .plain , target: self, action: #selector(nextTapped))
          } else {
          recordButton.setTitle("Tap to record", for: .normal)

          let errorAlert = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again", preferredStyle: .alert)
          errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
          present(errorAlert, animated: true)
          }

          }

          internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
          if !flag {
          finishRecording(success: false)
          }
          }
    
}
