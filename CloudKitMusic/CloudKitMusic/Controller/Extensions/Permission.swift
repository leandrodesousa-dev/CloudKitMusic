import UIKit
import AVFoundation

extension RecordWhistleViewController{
    
    //pede permissao do usuario
    internal func permissionUserRecorder(){

          //retorna a instancia do audio gravado
          recordingSession = AVAudioSession.sharedInstance()

          do {
          try recordingSession.setCategory(.playAndRecord, mode: .default)
          try recordingSession.setActive(true)
          /*preciso ir no info para solicitar também
          retorna a respota do usuário se podemos gravar ou nao*/
          recordingSession.requestRecordPermission { [unowned self] allowed in
             DispatchQueue.main.async {
                 if allowed{
                     self.loadRecordingUI()
                 } else {
                     self.loadFailUI()
                 }
             }
          }
          } catch {
          self.loadFailUI()
          }
          }
}
