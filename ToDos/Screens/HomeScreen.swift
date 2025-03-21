//
//  ContentView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 31/10/22.
//

import SwiftUI

struct HomeScreen: View {
    
    let user: User
    
    @StateObject private var itemsViewModel: ItemsViewModel
    
    @State var inputText: String = ""
    @State var showAddNewItemView: Bool = false
    @State var showUpdateItemView: Bool = false
    @State var selectedIndex: Int?
    @State var selectedItem: TodoItem?
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(user: User) {
        self.user = user
        _itemsViewModel = StateObject(wrappedValue: ItemsViewModel(user: user))
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Quicksand-Bold", size: 30)!]
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                
                VStack(alignment: .leading) {
                    
                    //MARK: Profile Header View
                    VStack(alignment: .leading, spacing: 15) {
                        NavigationLink {
                            ProfileScreen(user: user)
                        } label: {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        Text("Hi, \(user.name)")
                            .font(getFont(weight: .bold, size: 20))
                            .font(.title)
                        
                        Divider()
                    }
                    .padding(20)
                    
                    //MARK: List View
                    if (self.itemsViewModel.isLoading) {
                        LoaderView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if (self.itemsViewModel.todoItems.isEmpty) {
                        EmptyListView()
                    } else {
                        Text("Your To Dos")
                            .foregroundColor(.gray)
                            .font(getFont(weight: .semibold, size: 20))
                            .padding(.leading, 20)
                        ListView(itemsModelView: itemsViewModel,
                                 selectedIndex: $selectedIndex,
                                 selectedItem: $selectedItem,
                                 showUpdateItemView: $showUpdateItemView)
                    }
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    @State static var popup: Bool = true
    
    static var previews: some View {
        HomeScreen(user: User.dummyUser())
    }
}


