//
//  AddNewItemView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import SwiftUI

struct AddNewItemView: View {
    
    @Binding var isPresented: Bool
    
    @ObservedObject var todoItems: ItemsModelView
    
    @State var titleText : String = ""
    @State var isInputValid: Bool = false
    
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
                    
                    Text("Add New Task")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    TextField("Task name", text: $titleText)
                        .font(.system(size: 17.0))
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
                            todoItems.addItem(title: titleText)
                            isPresented = false
                        } label: {
                            Text("Add")
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
                .transition(.move(edge: .bottom))
                
                Spacer()
                Spacer()
            }
            .onAppear() {
                titleInFocus = true
            }
        }
        .ignoresSafeArea()
    }
}

struct AddNewItemView_Previews: PreviewProvider {
    
    @State static var isPresented: Bool = true
    
    static var previews: some View {
        AddNewItemView(isPresented: $isPresented, todoItems: ItemsModelView())
    }
}
