//
//  ContentView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 31/10/22.
//

import SwiftUI
import CoreData

struct HomeScreen: View {
    
    @StateObject var itemsModelView: ItemsModelView = ItemsModelView()
    @State var inputText: String = ""
    @State var showAddNewItemView: Bool = false
    @State var showUpdateItemView: Bool = false
    @State var itemToUpdate: ItemEntity = ItemEntity()
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Quicksand-Bold", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                //MARK: List View
                if (itemsModelView.todoItems.isEmpty) {
                    EmptyListView()
                } else {
                    ListView(itemsModelView: itemsModelView, itemToUpdate: $itemToUpdate, showUpdateItemView: $showUpdateItemView)
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
                    AddNewItemView(isPresented: $showAddNewItemView, todoItems: itemsModelView)
                }
                
                if (showUpdateItemView) {
                    UpdateItemView(isPresented: $showUpdateItemView, todoItems: itemsModelView, itemToUpdate: itemToUpdate)
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


