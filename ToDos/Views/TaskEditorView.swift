//
//  TaskEditorMode.swift
//  ToDos
//
//  Created by Balaganesh on 26/12/24.
//


import SwiftUI

enum TaskEditorMode {
    case add
    case edit
}

struct TaskEditorView: View {
    
    @Binding var isPresented: Bool
    
    var itemsViewModel: ItemsViewModel?
    let mode: TaskEditorMode
    
    let itemIndex: Int?
    let item: TodoItem?
    
    @State private var titleText: String = ""
    @State private var isInputValid: Bool = false
    
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
                    
                    Text(mode == .add ? "Add New Task" : "Edit Task")
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
                            if mode == .add {
                                itemsViewModel?.addItem(title: titleText)
                            } else if let index = itemIndex {
                                itemsViewModel?.updateTitle(newTitle: titleText, forItemAt: index)
                            }
                            isPresented = false
                        } label: {
                            Text(mode == .add ? "Add" : "Update")
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
                if mode == .edit {
                    titleText = item?.title ?? ""
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct TaskEditorView_Previews: View {
    @State var isPresented: Bool = true
    
    var body: some View {
        TaskEditorView(isPresented: $isPresented,
                       mode: .add,
                       itemIndex: nil,
                       item: nil)
    }
}

struct EditTaskEditorView_Previews: View {
    @State var isPresented: Bool = true
    
    var body: some View {
        TaskEditorView(isPresented: $isPresented,
                       mode: .edit,
                       itemIndex: 0,
                       item: TodoItem.dummyItem())
    }
}

#Preview {
    VStack {
        TaskEditorView_Previews()
        EditTaskEditorView_Previews()
    }
}
