//
//  AddNewItemView.swift
//  BoilerPlateSUI
//
//  Created by Balaganesh on 24/11/22.
//

import SwiftUI
import SwiftData

struct AddNewItemView: View {
    
    @Binding var isPresented: Bool
    
    let itemsViewModel: ItemsViewModel
    
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
                        .font(getFont(weight: .bold, size: UIFont.buttonFontSize))
                    
                    TextField("Task name", text: $titleText)
                        .font(getFont(weight: .medium, size: UIFont.labelFontSize))
                        .padding()
                        .frame(height: 50.0)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3).cornerRadius(10.0))
                        .focused($titleInFocus)
                        .onChange(of: titleText, initial: false, { oldValue, newValue in
                            isInputValid = newValue.count >= 3
                        })
                    
                    HStack {
                        Button {
                            isPresented = false
                        } label: {
                            Text("Cancel")
                                .secondaryButton()
                        }
                        
                        Button {
                            itemsViewModel.addItem(title: titleText)
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

struct AddNewItemView_Preview: View {
    @State var isPresented: Bool = true
    let modelContext = try! ModelContext(ModelContainer(for: TodoItem.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)))
    
    var body: some View {
        AddNewItemView(isPresented: $isPresented, itemsViewModel: ItemsViewModel(modelContext: modelContext, todoItems: []))
    }
}

#Preview {
    AddNewItemView_Preview()
}
