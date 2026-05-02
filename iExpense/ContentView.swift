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


#Preview {
    ContentView()
}
