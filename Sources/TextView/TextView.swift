#if !os(macOS)

import SwiftUI

@available(iOS 13.0, *)
public struct TextView: View {
	public struct Representable: UIViewRepresentable {
		public final class Coordinator: NSObject, UITextViewDelegate {
			private let parent: Representable
			
			public init(_ parent: Representable) {
				self.parent = parent
			}
			 
			private func setIsEditing(to value: Bool) {
				DispatchQueue.main.async {
					self.parent.isEditing = value
				}
			}
			
			public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
				parent.shouldChange?(range, text) ?? true
			}
			
			public func textViewDidChange(_ textView: UITextView) {
				parent.text = textView.text
                parent.recalculateHeight(view: textView, result: parent.$height)
			}
			
			public func textViewDidBeginEditing(_: UITextView) {
				setIsEditing(to: true)
			}
			
			public func textViewDidEndEditing(_: UITextView) {
				setIsEditing(to: false)
			}
		}
		
		@Binding private var text: String
		@Binding private var isEditing: Bool
		
		private let textAlignment: TextAlignment
		private let textHorizontalPadding: CGFloat
		private let textVerticalPadding: CGFloat
		private let font: UIFont
		private let textColor: UIColor
		private let backgroundColor: UIColor
		private let returnType: UIReturnKeyType
		private let contentType: ContentType?
		private let autocorrection: Autocorrection
		private let autocapitalization: Autocapitalization
		private let isSecure: Bool
		private let isEditable: Bool
		private let isSelectable: Bool
		private let isScrollingEnabled: Bool
		private let isUserInteractionEnabled: Bool
		private let shouldWaitUntilCommit: Bool
		private let shouldChange: ShouldChangeHandler?
        
        @Binding private var height: CGFloat
		
		public init(
			text: Binding<String>,
			isEditing: Binding<Bool>,
			textAlignment: TextAlignment,
			textHorizontalPadding: CGFloat,
			textVerticalPadding: CGFloat,
			font: UIFont,
			textColor: UIColor,
			backgroundColor: UIColor,
			returnType: UIReturnKeyType,
			contentType: ContentType?,
			autocorrection: Autocorrection,
			autocapitalization: Autocapitalization,
			isSecure: Bool,
			isEditable: Bool,
			isSelectable: Bool,
			isScrollingEnabled: Bool,
			isUserInteractionEnabled: Bool,
			shouldWaitUntilCommit: Bool,
			shouldChange: ShouldChangeHandler? = nil,
            height: Binding<CGFloat>
		) {
			_text = text
			_isEditing = isEditing
			
			self.textAlignment = textAlignment
			self.textHorizontalPadding = textHorizontalPadding
			self.textVerticalPadding = textVerticalPadding
			self.font = font
			self.textColor = textColor
			self.backgroundColor = backgroundColor
			self.returnType = returnType
			self.contentType = contentType
			self.autocorrection = autocorrection
			self.autocapitalization = autocapitalization
			self.isSecure = isSecure
			self.isEditable = isEditable
			self.isSelectable = isSelectable
			self.isScrollingEnabled = isScrollingEnabled
			self.isUserInteractionEnabled = isUserInteractionEnabled
			self.shouldWaitUntilCommit = shouldWaitUntilCommit
			self.shouldChange = shouldChange
            
            _height = height
		}
		
		public func makeCoordinator() -> Coordinator {
			.init(self)
		}
		
		public func makeUIView(context: Context) -> UITextView {
			let textView = UITextView()
			textView.delegate = context.coordinator
			return textView
		}
		
		public func updateUIView(_ textView: UITextView, context _: Context) {
			if !shouldWaitUntilCommit || textView.markedTextRange == nil {
				let textViewWasEmpty = textView.text.isEmpty
				let oldSelectedRange = textView.selectedTextRange
				
				textView.text = text
				textView.selectedTextRange = textViewWasEmpty
					? textView.textRange(
						from: textView.endOfDocument,
						to: textView.endOfDocument
					)
					: oldSelectedRange
			}
            
			textView.textAlignment = textAlignment
			textView.font = font
			textView.textColor = textColor
			textView.backgroundColor = backgroundColor
			textView.returnKeyType = returnType
			textView.textContentType = contentType
			textView.autocorrectionType = autocorrection
			textView.autocapitalizationType = autocapitalization
			textView.isSecureTextEntry = isSecure
			textView.isEditable = isEditable
			textView.isSelectable = isSelectable
			textView.isScrollEnabled = isScrollingEnabled
			textView.isUserInteractionEnabled = isUserInteractionEnabled
			
			textView.textContainerInset = .init(
				top: textVerticalPadding,
				left: textHorizontalPadding,
				bottom: textVerticalPadding,
				right: textHorizontalPadding
			)
            
            recalculateHeight(view: textView, result: self.$height)
            			
            DispatchQueue.main.async {
				_ = self.isEditing
					? textView.becomeFirstResponder()
					: textView.resignFirstResponder()
			}
		}
        
        // Source: https://stackoverflow.com/questions/56471973/how-do-i-create-a-multiline-textfield-in-swiftui
        
        fileprivate func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
            let newHeight = max(view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height, 50)
            if result.wrappedValue != newHeight {
                DispatchQueue.main.async {
                    result.wrappedValue = newHeight // !! must be called asynchronously
                }
            }
        }
	}
    
    
	
	public typealias TextAlignment = NSTextAlignment
	public typealias ContentType = UITextContentType
	public typealias Autocorrection = UITextAutocorrectionType
	public typealias Autocapitalization = UITextAutocapitalizationType
	public typealias ShouldChangeHandler = (NSRange, String) -> Bool
	
	public static let defaultFont = UIFont.preferredFont(forTextStyle: .body)
	
	@Binding private var text: String
	@Binding private var isEditing: Bool
	
	private let placeholder: String?
	private let textAlignment: TextAlignment
	private let textHorizontalPadding: CGFloat
	private let textVerticalPadding: CGFloat
	private let placeholderAlignment: Alignment
	private let placeholderHorizontalPadding: CGFloat
	private let placeholderVerticalPadding: CGFloat
	private let font: UIFont
	private let textColor: UIColor
	private let placeholderColor: Color
	private let backgroundColor: UIColor
	private let returnType: UIReturnKeyType
	private let contentType: ContentType?
	private let autocorrection: Autocorrection
	private let autocapitalization: Autocapitalization
	private let isSecure: Bool
	private let isEditable: Bool
	private let isSelectable: Bool
	private let isScrollingEnabled: Bool
	private let isUserInteractionEnabled: Bool
	private let shouldWaitUntilCommit: Bool
	private let shouldChange: ShouldChangeHandler?
    
    @State private var height: CGFloat = 50
	
	public init(
		text: Binding<String>,
		isEditing: Binding<Bool>,
		placeholder: String? = nil,
		textAlignment: TextAlignment = .left,
		textHorizontalPadding: CGFloat = 0,
		textVerticalPadding: CGFloat = 7,
		placeholderAlignment: Alignment = .topLeading,
		placeholderHorizontalPadding: CGFloat = 4.5,
		placeholderVerticalPadding: CGFloat = 7,
		font: UIFont = Self.defaultFont,
		textColor: UIColor = .label,
		placeholderColor: Color = .init(.placeholderText),
		backgroundColor: UIColor = .clear,
		returnType: UIReturnKeyType = .default,
		contentType: ContentType? = nil,
		autocorrection: Autocorrection = .default,
		autocapitalization: Autocapitalization = .sentences,
		isSecure: Bool = false,
		isEditable: Bool = true,
		isSelectable: Bool = true,
		isScrollingEnabled: Bool = true,
		isUserInteractionEnabled: Bool = true,
		shouldWaitUntilCommit: Bool = true,
		shouldChange: ShouldChangeHandler? = nil,
        height: CGFloat = 50
	) {
		_text = text
		_isEditing = isEditing
		
		self.placeholder = placeholder
		self.textAlignment = textAlignment
		self.textHorizontalPadding = textHorizontalPadding
		self.textVerticalPadding = textVerticalPadding
		self.placeholderAlignment = placeholderAlignment
		self.placeholderHorizontalPadding = placeholderHorizontalPadding
		self.placeholderVerticalPadding = placeholderVerticalPadding
		self.font = font
		self.textColor = textColor
		self.placeholderColor = placeholderColor
		self.backgroundColor = backgroundColor
		self.returnType = returnType
		self.contentType = contentType
		self.autocorrection = autocorrection
		self.autocapitalization = autocapitalization
		self.isSecure = isSecure
		self.isEditable = isEditable
		self.isSelectable = isSelectable
		self.isScrollingEnabled = isScrollingEnabled
		self.isUserInteractionEnabled = isUserInteractionEnabled
		self.shouldWaitUntilCommit = shouldWaitUntilCommit
		self.shouldChange = shouldChange
        self.height = height
	}
	
	private var _placeholder: String? {
		text.isEmpty ? placeholder : nil
	}
	
	private var representable: Representable {
		.init(
			text: $text,
            isEditing: $isEditing,
			textAlignment: textAlignment,
			textHorizontalPadding: textHorizontalPadding,
			textVerticalPadding: textVerticalPadding,
			font: font,
			textColor: textColor,
			backgroundColor: backgroundColor,
			returnType: returnType,
			contentType: contentType,
			autocorrection: autocorrection,
			autocapitalization: autocapitalization,
			isSecure: isSecure,
			isEditable: isEditable,
			isSelectable: isSelectable,
			isScrollingEnabled: isScrollingEnabled,
			isUserInteractionEnabled: isUserInteractionEnabled,
			shouldWaitUntilCommit: shouldWaitUntilCommit,
			shouldChange: shouldChange,
            height: $height
		)
	}
	
	public var body: some View {
		GeometryReader { geometry in
			ZStack {
				self.representable
                    .frame(minWidth: geometry.size.width,
                           maxWidth: geometry.size.width,
                           minHeight: self.height,
                           maxHeight: self.height)
                
				self._placeholder.map { placeholder in
					Text(placeholder)
						.font(.init(self.font))
						.foregroundColor(self.placeholderColor)
						.padding(.horizontal, self.placeholderHorizontalPadding)
						.padding(.vertical, self.placeholderVerticalPadding)
                        .frame(
                            minWidth: geometry.size.width,
                            maxWidth: geometry.size.width,
                            minHeight: self.height,
                            maxHeight: self.height,
                            alignment: self.placeholderAlignment
                        )
						.onTapGesture {
							self.isEditing = true
						}
				}
			}
		}
	}
}

#endif


struct FeedbackInput: View {
    @Binding var feedback: String
    var placeholder: String
    @Binding var active: Bool
    
    
    
    var body: some View {
        TextView(text: self.$feedback,
                 isEditing: self.$active,
                 placeholder: self.placeholder,
                 font: UIFont(name: "Nunito-Regular", size: 16)!,
                 backgroundColor: UIColor.gray)
            .onTapGesture { self.active.toggle() }
        
    }
}

struct FeedbackInput_Previews: PreviewProvider {
    @State static var feedback = "Super long multiline input font that should wrap when it gets to the edge of the page and if it doesn't then something is wrong"
    @State static var active = false
    
    static var previews: some View {
        FeedbackInput(feedback: $feedback, placeholder: "How can we improve?", active: $active)
    }
}
