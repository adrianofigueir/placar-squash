//
//  ViewControllerSumula.h
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>
#import "DadosJogo.h"
#import "DadosSumula.h"

@interface ViewControllerSumula: UIViewController <MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
    
    int tamanhoLinha;
}
@property (strong, nonatomic) DadosSumula *dadosSumula;
@property (strong, nonatomic) DadosJogo *dadosJogo;

@property (strong, nonatomic) IBOutlet UITextField *txData;
@property (strong, nonatomic) IBOutlet UITextField *txArbitro;
//@property (strong, nonatomic) IBOutlet UITextField *txTorneioCampeonato;
@property (strong, nonatomic) IBOutlet UITextField *txHora;
@property (strong, nonatomic) IBOutlet UITextField *txMarcador;
@property (strong, nonatomic) IBOutlet UITextField *txQuadra;
@property (strong, nonatomic) IBOutlet UIDatePicker *dpDatePickerData;
@property (strong, nonatomic) IBOutlet UIDatePicker *dpDatePickerHora;

- (IBAction)doneKeyboard:(id)sender;
- (IBAction)gerarPdfSumula:(id)sender;
@end
