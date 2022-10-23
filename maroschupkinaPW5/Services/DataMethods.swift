//
//  DataMethods.swift
//  maroschupkinaPW4
//
//  Created by Marina Roshchupkina on 09.10.2022.
//

import Foundation
class Storage{
    static var shared = Storage()
    var dataSource = [ShortNote]()
    
    public func saveData(){
        do {
        UserDefaults.standard.set(try PropertyListEncoder().encode(dataSource), forKey: "notes")
        
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    public func loadData(){
        if let storedObject: Data = UserDefaults.standard.data(forKey: "notes")
        {
            do
            {
                let notes = try PropertyListDecoder().decode([ShortNote].self, from: storedObject)
                dataSource = notes
            }
            catch
            {
                print(error.localizedDescription)
            }
            
        }
    }
    
}
