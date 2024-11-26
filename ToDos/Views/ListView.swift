//
//  ListView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 30/11/22.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    let itemsModelView: ItemsViewModel
    
    @Binding var itemToUpdate: TodoItem?
    @Binding var showUpdateItemView: Bool
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        List {
            ForEach(itemsModelView.todoItems) { item in
                
                HStack(spacing: 15.0) {
                    
                    CheckmarkView(isChecked: item.isCompleted)
                    .onTapGesture {
                        feedbackGenerator.impactOccurred()
                        itemsModelView.updateCompletion(item: item)
                    }
                    
                    
                    Button {
                        self.itemToUpdate = item
                        self.showUpdateItemView = true
                    } label: {
                        Text(item.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(getFont(weight: .medium, size: UIFont.labelFontSize))
                            .padding(.vertical, 16.0)
                    }
                    .tint(Color("TextColor"))
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 16.0, bottom: 0, trailing: 16.0))
            }
            .onDelete(perform: itemsModelView.deleteItem)
            .onMove(perform: itemsModelView.moveItem)
        }
        .listStyle(.grouped)
    }
}


struct EmptyListView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .foregroundColor(Color("TextColor").opacity(0.4))
                .frame(width: 60, height: 60)
            
            
            Text("List is Empty")
                .font(.title)
                .foregroundColor(Color("TextColor").opacity(0.4))
                .frame(maxWidth: .infinity)
            
            Spacer()
            Spacer()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
