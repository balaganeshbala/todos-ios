//
//  UpdateItemView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 14/12/22.
//

import SwiftUI

struct UpdateItemView: View {
    @Binding var isPresented: Bool
    
    @ObservedObject var todoItems: ItemsModelView
    
    @State var titleText : String = ""
    @State var isInputValid: Bool = false
    
    let itemToUpdate: ItemModel
    
    @FocusState private var titleInFocus: Bool
    
    var body: some View {
        
        ZStack {
            
            VStack {
                Color.gray.opacity(0.5)
            }
            .onTapGesture {
                isPresented = false
            }
            
            VStack {
                Spacer()
                
                VStack(spacing: 20.0) {
                    
                    Text("Edit Task")
                        .font(getFont(weight: .bold, size: UIFont.buttonFontSize))
                    
                    TextField("Task name", text: $titleText)
                        .font(getFont(weight: .medium, size: UIFont.labelFontSize))
                        .padding()
                        .frame(height: 50.0)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3).cornerRadius(10.0))
                        .focused($titleInFocus)
                        .onChange(of: titleText) { newValue in
                            isInputValid = newValue.count >= 3
                        }
                    
                    HStack {
                        Button {
                            isPresented = false
                        } label: {
                            Text("Cancel")
                                .secondaryButton()
                        }
                        
                        Button {
                            todoItems.updateItem(item: ItemModel(id: itemToUpdate.id, title: titleText, isCompleted: itemToUpdate.isCompleted))
                            isPresented = false
                        } label: {
                            Text("Update")
                                .primaryButton()
                                .grayscale(isInputValid ? 0.0 : 1.0)
                                .opacity(isInputValid ? 1.0 : 0.5)
                        }
                        .disabled(!isInputValid)
                    }
                }
                .padding()
                .background(Color("ThemeColor"))
                .cornerRadius(10.0)
                .padding(.horizontal, 20)
                
                Spacer()
                Spacer()
            }
            .onAppear() {
                titleInFocus = true
                titleText = itemToUpdate.title
            }
        }
        .ignoresSafeArea()
    }
}

struct UpdateItemView_Previews: PreviewProvider {
    
    @State static var isPresented: Bool = true
    
    static let itemModel: ItemModel = ItemModel.defaultItem()
    
    static var previews: some View {
        UpdateItemView(isPresented: $isPresented, todoItems: ItemsModelView(), itemToUpdate: itemModel)
    }
}
