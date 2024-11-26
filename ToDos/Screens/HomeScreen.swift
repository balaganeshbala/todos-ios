//
//  ContentView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 31/10/22.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: [SortDescriptor(\TodoItem.orderIndex)]) var todoItems: [TodoItem] = []
    
    @State var inputText: String = ""
    @State var showAddNewItemView: Bool = false
    @State var showUpdateItemView: Bool = false
    @State var itemToUpdate: TodoItem?
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Quicksand-Bold", size: 30)!]
    }
    
    var body: some View {
        
        let itemsViewModel = ItemsViewModel(modelContext: modelContext, todoItems: todoItems)
        
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                //MARK: List View
                if (todoItems.isEmpty) {
                    EmptyListView()
                } else {
                    ListView(itemsModelView: itemsViewModel,
                             itemToUpdate: $itemToUpdate,
                             showUpdateItemView: $showUpdateItemView)
                }
                
                
                //MARK: Add Button
                Button {
                    feedbackGenerator.impactOccurred()
                    showAddNewItemView.toggle()
                } label: {
                    PlusImageView()
                }
                .padding()
                .padding(.trailing)
                
                
                if (showAddNewItemView) {
                    AddNewItemView(isPresented: $showAddNewItemView, itemsViewModel: itemsViewModel)
                }
                
                if (showUpdateItemView) {
                    UpdateItemView(isPresented: $showUpdateItemView,
                                   todoItems: itemsViewModel,
                                   itemToUpdate: self.itemToUpdate
                        )
                }
            }
            .navigationTitle("To Do List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State static var popup: Bool = true
    
    static let modelContext = try! ModelContext(ModelContainer(for: TodoItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)))
    
    static var previews: some View {
        HomeScreen()
            .modelContext(modelContext)
    }
}


