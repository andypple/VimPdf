//
//  DocModel.swift
//  VimPdf
//
//  Created by phatle on 11/15/20.
//

import Foundation
import CoreData

class DocModel {
    var context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    func create(fileUrl: URL) {
        let request = Doc.fetchRequest() as NSFetchRequest<Doc>
        request.predicate = NSPredicate(format: "fileUrl == %@", fileUrl as CVarArg)
        let items = try! context.fetch(request)
        if (items.last == nil) {
            let newDoc = Doc(context: self.context)
            newDoc.fileUrl = fileUrl
            newDoc.openedAt = Date()
        } else {
            let doc = items.last!
            doc.openedAt = Date()
        }
        
        try! self.context.save()
    }
    func last() -> Doc? {
        let request = Doc.fetchRequest() as NSFetchRequest<Doc>
        request.sortDescriptors = [NSSortDescriptor.init(key: "openedAt", ascending: true)]
        let items = try! context.fetch(request)
        return items.last
    }
}