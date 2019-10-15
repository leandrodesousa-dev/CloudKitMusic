import CloudKit
import UIKit

class Whistle: NSObject {

    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
