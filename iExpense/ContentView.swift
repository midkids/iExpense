//
//  ContentView.swift
//  iExpense
//
//  Created by Myron Snelson on 4/27/26.
//

import SwiftUI

// This one object contains all our data
// Recall: 1) Structs are always owned by one unique thing
//   whereas Classes can have multiple owners
// 2) Classes do not need the keyword mutating with
//  methods that change their properties
// IMPORTANT: If we have two SwiftUI views
//   and we send them both the same Struct
//   with which to work,
//   each view will have unique copies of that Struct
//   If one view changes it, those changes will not
//   appear in the other view
//   They are independent copies of the same data
//   For a class, both views share the same data
// struct User {
// @Observable causes SwiftUI to recognize change
//   in a property of a class
//   and any views that read that property
//   will be updated
/*
// Using @State with classes
// Sharing SwiftUI state with @Observable
//
@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}

struct ContentView: View {
    // When we use @State,
    // we are asking SwiftUI to watch this
    // property for changes
    // When it does change, the whole body view
    //   will be reinvoked with new data inside
    // Struct
    // So...when we change a property inside the Struct,
    //   SwiftUI recreated the whole Struct
    // This causes an @State to detect a change
    //   the entire body view is reinvoked
    // Class
    // Swift modifies these values directly inside
    //   the constant class around it
    // The class object is not changing, only the values
    // inside are changing
    // The @State property does not detect a change
    //   the variable user itself does not change
    // IMPORTANT: We can change that behavior by
    //   adding @Observable to the class
    @State private var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName)")
            // Overtyping "Bilbo" with "Frodo" in the TextField
            // will change firstName in the Text view when the
            // User is a Struct
            // It will not change the Text view when the
            // User is a Class
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
        .padding()
    }
}
 */

/*
// Showing and hiding views
//
// Will show this second view via sheet
// Can drag this view away
struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    let name: String
    var body: some View {
        Text("Hello, \(name)!")
        Button("Dismiss") {
            dismiss()
        }
    }
}

struct ContentView: View {
    @State private var showingSecondSheet = false
    var body: some View {
        Button("Show Second Sheet") {
            showingSecondSheet.toggle()
        }
        // attach our second sheet into our
        // current view hierarchy
        .sheet(isPresented: $showingSecondSheet) {
            SecondView(name: "Fred")
        }
    }
}
*/

/*
// Deleting items using onDelete()
//
struct ContentView: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Only dynamic rows in a list are deletable
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    // user must swipe from right to left
                    // to delete a row
                    .onDelete(perform: removeRows)
                }
                Button("Add number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
            // Allows deletion of muliple rows
            .toolbar {
                EditButton()
            }
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}
 */

/*
// Storing user settings with UserDefaults
//
// The simplest way to read and write a small of data
// is through user defaults
// It is a great way to keep user preferences
// Storing too many user defaults will slow the
// loading of your app
// Should store no more than 512 KB

struct ContentView: View {
    
//    @State private var tapCount = 0
    
    // If the key cannot be found (as in the first time
    // the app runs), the value of Tap defaults to 0
    // because it is an integer
    // Booleans default to false
    // iOS buffers writing default values and
    // it can take a few seconds to write all the user defaults
    // However, in theory, nothing will ever be lost
//    @State private var tapCount =
//     UserDefaults.standard.integer(forKey: "Tap")
    
    // IMPORTANT: App storage is a MUCH better choice
    // than user defaults (user defaults actually works
    // by using app storage)
    // When the value of tapCount changes,
    //   SwiftUI will reinvoke the body property automatically
    //   This makes sure the user interface always
    //   reflects the latest value
    // The default value is used if there is no value set
    @AppStorage("tapCount") private var tapCount = 0
    
    var body: some View {
        Button("Tap Count: \(tapCount)") {
            tapCount += 1
            // Standard is the built in instance of User Defaults
            // that is attached to our apps (can create your own)
            // Single set method and
            // It can store integers, strings, booleans
            // Must give a string name (e.g. "Tap")
            // to the value we are writing
            UserDefaults.standard.set(tapCount, forKey: "Tap")
        }
    }
}
*/

// Archiving Swift objects with Codable
//
// For complex data types such as
//   custom Swift types
// Here we have simple text, but could also have
//   other simple types (e.g. integers, booleans, doubles,
//   arrays, and dictionaries)
// IMPORTANT: use protocol Codable
//   which is responsible for archiving and unarchiving data
//   that means it can convert objects like this one
//   into plain text and back again
// NEW TYPE: JSON - JavaScript Object Notation
// is the most common type used with Codable
struct User: Codable {
    let firstName: String
    let lastName: String
}

/*
struct ContentView: View {
    @State private var user = User(firstName: "Taylor", lastName: "Swift")
    var body: some View {
        Button("Save User") {
            // The value of the data variable
            // is encoded in type Data
            // that can hold any type of data
            // object -> JSON binary data format type Data
            // To do JSON -> object, we would use JSONDecoder
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(user) {
                
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
      
    }
}
*/

// The actual iExpense project
// - Building a list we can delete from
// - Working with identifiable items in SwiftUI
// - Sharing an observed object with a new view
// - Making changes permanent with UserDefaults
// - Final polish
//
// Making the struct conform to the protcol Identifiable
// Lets SwiftUI know this data can be uniquely identifed
// Identifiable requires a property named id that makes
// the struct unique
struct ExpenseItem: Identifiable {
    // this will make a unique id for every entry in the array
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

// Clases the use the observable protocol,
//  can be used in more than one SwiftUI view
//  and all of those views will be updated
//  when the relevant properties of the object changes
@Observable
class Expenses {
    var items = [ExpenseItem]()
}

struct ContentView: View {
    // Using @State here is just to keep the object alive
    //   It is the @Observable macro that notice changes
    //   and notifies SwiftUI views to update themselves
    @State private var expenses = Expenses()
    
    @State private var showingAddExpense = false
    var body: some View {
        NavigationStack {
            // This is a dynamic list. SwiftUI needs to know
            // how to identify each single view
            // inside there uniquely
            // so it can tell what view has changed
            // when the data changes
            List {
                // Could cause problems if name is not unique
                // It works in this case because we are deleting
                // a single specific row, one at a time
                // But many other cases, that extra information
                // will not be present causing our app to
                // behave strangely
                // ForEach(expenses.items, id: \.name) {item in
                
                // Here is the fix because id will always
                // be unique
                // ForEach(expenses.items, id: \.id) {item in
                
                // After adding Identifiable protocol
                // to the ExpenseItem struct,
                // we no longer need to have an id in
                // our ForEach
                ForEach(expenses.items) {item in
                    Text(item.name)
                }
                // must use ForEach to enable onDelete
                // allows swipe left to delete an item
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            // Add expenses
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    // For testing UI only
                    // let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5.0)
                    // expenses.items.append(expense)
                    
                    // showAddExpense is bound to our sheet
                    // so SwiftUI will show the AddView
                    // when it is true
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                // Here we are sharing the expenses object
                // from the ContentView with the AddView
                // IMPORTANT: Both views will share the same
                // observable class
                // RESULT: both view will watch for changes
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
