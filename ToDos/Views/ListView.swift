//
//  ListView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 30/11/22.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var itemsModelView: ItemsModelView
    @State var updatedItem: ItemModel = ItemModel.defaultItem()
    
    @Binding var itemToUpdate: ItemModel
    @Binding var showUpdateItemView: Bool
    
    var body: some View {
        List {
            ForEach(itemsModelView.todoItems) { item in
                
                HStack(spacing: 15.0) {
                    
                    CheckmarkView(isChecked: item.isCompleted)
                    .onTapGesture {
                        self.updatedItem = item
                    }
                    
                    
                    Button {
                        self.itemToUpdate = item
                        self.showUpdateItemView = true
                    } label: {
                        Text(item.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 17.0))
                            .padding(.vertical, 8.0)
                    }
                    .tint(Color("TextColor"))
                }
            }
            .onDelete(perform: itemsModelView.deleteItem)
            .onMove(perform: itemsModelView.moveItem)
            .onChange(of: self.updatedItem, perform: itemsModelView.updateCompletion)
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
                .foregroundColor(Color.black.opacity(0.3))
                .frame(width: 60, height: 60)
            
            
            Text("List is Empty")
                .font(.title)
                .foregroundColor(Color.black.opacity(0.3))
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
