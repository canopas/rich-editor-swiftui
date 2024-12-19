//
//  RichTextCoordinator+Subscriptions.swift
//  RichEditorSwiftUI
//
//  Created by Divyesh Vekariya on 21/10/24.
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    import SwiftUI

    extension RichTextCoordinator {

        /// Subscribe to observable context state changes.
        ///
        /// The coordinator subscribes to both actions triggered
        /// by various buttons via the context, but also to some
        /// context value that are changed through view bindings.
        func subscribeToUserActions() {
            context.actionPublisher.sink { [weak self] action in
                self?.handle(action)
            }
            .store(in: &cancellables)

            subscribeToAlignment()
            subscribeToFontName()
            subscribeToFontSize()
            subscribeToIsEditable()
            subscribeToIsEditingText()
            subscribeToLineSpacing()
        }
    }

    extension RichTextCoordinator {

        fileprivate func subscribe<T>(
            to publisher: Published<T>.Publisher,
            action: @escaping (T) -> Void
        ) {
            publisher
                .sink(receiveValue: action)
                .store(in: &cancellables)
        }

        fileprivate func subscribeToAlignment() {
            subscribe(to: context.$textAlignment) { [weak self] in
                self?.handle(.setAlignment($0))
            }
        }

        fileprivate func subscribeToFontName() {
            subscribe(to: context.$fontName) { [weak self] in
                self?.textView.setRichTextFontName($0)
            }
        }

        fileprivate func subscribeToFontSize() {
            subscribe(to: context.$fontSize) { [weak self] in
                self?.textView.setRichTextFontSize($0)
            }
        }

        fileprivate func subscribeToIsEditable() {
            subscribe(to: context.$isEditable) { [weak self] in
                self?.setIsEditable(to: $0)
            }
        }

        fileprivate func subscribeToIsEditingText() {
            subscribe(to: context.$isEditingText) { [weak self] in
                self?.setIsEditing(to: $0)
            }
        }

        // TODO: Not done yet
        fileprivate func subscribeToLineSpacing() {
            // subscribe(to: context.$lineSpacing) { [weak self] in
            //     self?.textView.setRichTextLineSpacing($0)
            // }
        }
    }
#endif
