//
//  AddView .swift
//  iExpense
//
//  Created by Myron Snelson on 5/6/26.
//

import SwiftUI

struct AddView: View {
    // Reads the dismiss value from the environment
    // Need this statement to dismiss add expense
    // screen when the time is right
    // It controls the views environment
    // The isPresented parameter,
    //   which references the showingAddExpense variable
    //   is linked to the environment
    //   and is automatically turned to false
    //   when the AdView view is dismissed
    // IMPORTANT: We do not have to specify type
    // It will call the dismiss function
    //   to dismiss the AddView view
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    // The AddView expects to be made with
    // an Expenses object that is shared with it
    // upon instantiation
    // IMPORTANT: Both views will share the same
    // observable class
    // (made observable in ContentView)
    // RESULT: both view will watch for changes
    // IMPORTANT: Both the ContentView and the AddView
    //   will share the same list of expense items
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    // dismisses this sheet
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    // Our expenses will be a new Expenses object
    // That works because:
    // it is just for preview purposes
    AddView(expenses: Expenses())
}
