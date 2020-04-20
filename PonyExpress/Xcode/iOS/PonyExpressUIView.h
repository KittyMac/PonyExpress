/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Customized view for iOS & tvOS
*/

#import <Metal/Metal.h>
#import <UIKit/UIKit.h>
#import "PonyExpressView.h"

@interface PonyExpressUIView : PonyExpressView <UIKeyInput, UITextInputTraits>

@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;   // default is UITextAutocapitalizationTypeSentences
@property(nonatomic) UITextAutocorrectionType autocorrectionType;           // default is UITextAutocorrectionTypeDefault
@property(nonatomic) UITextSpellCheckingType spellCheckingType;             // default is UITextSpellCheckingTypeDefault;
@property(nonatomic) UITextSmartQuotesType smartQuotesType;                 // default is UITextSmartQuotesTypeDefault;
@property(nonatomic) UITextSmartDashesType smartDashesType;                 // default is UITextSmartDashesTypeDefault;
@property(nonatomic) UITextSmartInsertDeleteType smartInsertDeleteType;     // default is UITextSmartInsertDeleteTypeDefault;
@property(nonatomic) UIKeyboardType keyboardType;                           // default is UIKeyboardTypeDefault
@property(nonatomic) UIKeyboardAppearance keyboardAppearance;               // default is UIKeyboardAppearanceDefault
@property(nonatomic) UIReturnKeyType returnKeyType;                         // default is UIReturnKeyDefault (See note under UIReturnKeyType enum)
@property(nonatomic) BOOL enablesReturnKeyAutomatically;                    // default is NO (when YES, will automatically disable return key when text widget has zero-length contents, and will automatically enable when text widget has non-zero-length contents)
@property(nonatomic,getter=isSecureTextEntry) BOOL secureTextEntry;         // default is NO

// The textContentType property is to provide the keyboard with extra information about the semantic intent of the text document.
@property(null_unspecified,nonatomic,copy) UITextContentType textContentType API_AVAILABLE(ios(10.0)); // default is nil

// The passwordRules property is used to communicate requirements for passwords for your service
// to ensure iOS can generate compatible passwords for users. It only works when secureTextEntry
// is YES. You do not need to use this property if the passwords that iOS generates are already
// compatible with your service. You can learn more about the purpose of and syntax for these rules
// on the Password Rules documentation guide.
@property(nullable,nonatomic,copy) UITextInputPasswordRules *passwordRules API_AVAILABLE(ios(12.0)); // default is nil

@property (nonatomic, retain) NSTimer * _Nullable keyboardAnimationTimer;

@property (nonatomic, retain) NSMutableArray * _Nullable trackingTouches;

- (void)showKeyboard;
- (void)hideKeyboard;

@end
