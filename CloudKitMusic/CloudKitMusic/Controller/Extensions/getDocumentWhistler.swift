import UIKit

extension RecordWhistleViewController {
    
    //metodo que salva o audio
   class func getDocumentsDirectory() -> URL{
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           let documentsDirectory = paths[0]

           return documentsDirectory
           }
    
    //metodo que pega o endereço URL do audio armazenado
   class func getWhistleUrl() -> URL{
   return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
   }

    
}
