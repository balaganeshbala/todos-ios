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
    
    @Binding var selectedIndex: Int?
    @Binding var selectedItem: TodoItem?
    @Binding var showUpdateItemView: Bool
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        List {
            ForEach(Array(itemsModelView.todoItems.enumerated()), id: \.element.id) { index, item in
                
                HStack(spacing: 15.0) {
                    
                    CheckmarkView(isChecked: item.isCompleted)
                    .onTapGesture {
                        feedbackGenerator.impactOccurred()
                        itemsModelView.updateCompletion(itemIndex: index)
                    }
                    
                    
                    Button {
                        self.selectedIndex = index
                        self.selectedItem = item
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
        .listStyle(.inset)
    }
}


struct EmptyListView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .foregroundColor(Color("TextColor").opacity(0.4))
                .frame(width: 50, height: 50)
            
            
            Text("No To Dos")
                .font(getFont(weight: .medium, size: 20))
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
