import UIKit

extension RecordWhistleViewController {
    
   class func getDocumentsDirectory() -> URL{
           let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
           let documentsDirectory = paths[0]

           return documentsDirectory
           }

   class func getWhistleUrl() -> URL{
   return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
   }

    
}
