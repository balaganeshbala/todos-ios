//
//  ContentView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 31/10/22.
//

import SwiftUI

struct HomeScreen: View {    
    @StateObject var itemsViewModel = ItemsViewModel()
    
    @State var inputText: String = ""
    @State var showAddNewItemView: Bool = false
    @State var showUpdateItemView: Bool = false
    @State var selectedIndex: Int?
    @State var selectedItem: TodoItem?
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Quicksand-Bold", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                //MARK: List View
                if (self.itemsViewModel.isLoading) {
                    LoaderView()
                        .frame(maxWidth: .infinity)
                } else if (self.itemsViewModel.todoItems.isEmpty) {
                    EmptyListView()
                } else {
                    ListView(itemsModelView: itemsViewModel,
                             selectedIndex: $selectedIndex,
                             selectedItem: $selectedItem,
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
                    TaskEditorView(isPresented: $showAddNewItemView, itemsViewModel: itemsViewModel,
                                   mode: .add,
                                   itemIndex: nil,
                                   item: nil)
                }
                
                if (showUpdateItemView) {
                    TaskEditorView(isPresented: $showUpdateItemView, itemsViewModel: self.itemsViewModel,
                                   mode: .edit,
                                   itemIndex: self.selectedIndex,
                                   item: self.selectedItem)
                
                }
            }
            .navigationTitle("To Do List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State static var popup: Bool = true
    
    static var previews: some View {
        HomeScreen()
    }
}


