import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
extension View {
  public func confirmationDialog<ButtonAction>(
    store: Store<
    PresentationState<ConfirmationDialogState<ButtonAction>>,
    PresentationAction<ButtonAction>
    >
  ) -> some View {
    self.confirmationDialog(store: store, state: { $0 }, action: { $0 })
  }

  public func confirmationDialog<State, Action, ButtonAction>(
    store: Store<PresentationState<State>, PresentationAction<Action>>,
    state toDestinationState: @escaping (State) -> ConfirmationDialogState<ButtonAction>?,
    action fromDestinationAction: @escaping (ButtonAction) -> Action
  ) -> some View {
    self.modifier(
      PresentationConfirmationDialogModifier(
        viewStore: ViewStore(store, removeDuplicates: { $0.id == $1.id }),
        toDestinationState: toDestinationState,
        fromDestinationAction: fromDestinationAction
      )
    )
  }
}

extension View {
  /// Displays a dialog when the store's state becomes non-`nil`, and dismisses it when it becomes
  /// `nil`.
  ///
  /// - Parameters:
  ///   - store: A store that describes if the dialog is shown or dismissed.
  ///   - dismissal: An action to send when the dialog is dismissed through non-user actions, such
  ///     as when a dialog is automatically dismissed by the system. Use this action to `nil` out
  ///     the associated dialog state.
  @available(iOS 13, *)
  @available(macOS 12, *)
  @available(tvOS 13, *)
  @available(watchOS 6, *)
  @ViewBuilder public func confirmationDialog<Action>(
    _ store: Store<ConfirmationDialogState<Action>?, Action>,
    dismiss: Action
  ) -> some View {
    if #available(iOS 15, tvOS 15, watchOS 8, *) {
      self.modifier(
        NewConfirmationDialogModifier(
          viewStore: ViewStore(store, observe: { $0 }, removeDuplicates: { $0?.id == $1?.id }),
          dismiss: dismiss
        )
      )
    } else {
      #if !os(macOS)
        self.modifier(
          OldConfirmationDialogModifier(
            viewStore: ViewStore(store, observe: { $0 }, removeDuplicates: { $0?.id == $1?.id }),
            dismiss: dismiss
          )
        )
      #endif
    }
  }
}

// NB: Workaround for iOS 14 runtime crashes during iOS 15 availability checks.
@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
private struct NewConfirmationDialogModifier<Action>: ViewModifier {
  @StateObject var viewStore: ViewStore<ConfirmationDialogState<Action>?, Action>
  let dismiss: Action

  func body(content: Content) -> some View {
    content.confirmationDialog(
      (viewStore.state?.title).map { Text($0) } ?? Text(""),
      isPresented: viewStore.binding(send: dismiss).isPresent(),
      titleVisibility: viewStore.state.map { .init($0.titleVisibility) } ?? .automatic,
      presenting: viewStore.state,
      actions: {
        ForEach($0.buttons) {
          Button($0) { action in
            if let action = action {
              viewStore.send(action)
            }
          }
        }
      },
      message: { $0.message.map { Text($0) } }
    )
  }
}

@available(iOS 13, *)
@available(macOS 12, *)
@available(tvOS 13, *)
@available(watchOS 6, *)
private struct OldConfirmationDialogModifier<Action>: ViewModifier {
  @ObservedObject var viewStore: ViewStore<ConfirmationDialogState<Action>?, Action>
  let dismiss: Action

  func body(content: Content) -> some View {
    #if !os(macOS)
      return content.actionSheet(item: viewStore.binding(send: dismiss)) {
        ActionSheet($0) { action in
          if let action = action {
            viewStore.send(action)
          }
        }
      }
    #else
      return EmptyView()
    #endif
  }
}

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
private struct PresentationConfirmationDialogModifier<State, Action, ButtonAction>: ViewModifier {
  @StateObject var viewStore: ViewStore<PresentationState<State>, PresentationAction<Action>>
  let toDestinationState: (State) -> ConfirmationDialogState<ButtonAction>?
  let fromDestinationAction: (ButtonAction) -> Action

  func body(content: Content) -> some View {
    let confirmationDialogState = self.viewStore.wrappedValue.flatMap(self.toDestinationState)
    content.confirmationDialog(
      (confirmationDialogState?.title).map(Text.init) ?? Text(""),
      isPresented: self.viewStore.binding(
        get: { $0.wrappedValue.flatMap(self.toDestinationState) != nil },
        send: .dismiss
      ),
      titleVisibility: (confirmationDialogState?.titleVisibility).map(Visibility.init)
      ?? .automatic,
      presenting: confirmationDialogState,
      actions: { confirmationDialogState in
        ForEach(confirmationDialogState.buttons) { button in
          Button(role: button.role.map(ButtonRole.init)) {
            switch button.action.type {
            case let .send(action):
              if let action = action {
                viewStore.send(.presented(self.fromDestinationAction(action)))
              }
            case let .animatedSend(action, animation):
              if let action = action {
                _ = withAnimation(animation) {
                  viewStore.send(.presented(self.fromDestinationAction(action)))
                }
              }
            }
          } label: {
            Text(button.label)
          }
        }
      },
      message: {
        $0.message.map(Text.init) ?? Text("")
      }
    )
  }
}
