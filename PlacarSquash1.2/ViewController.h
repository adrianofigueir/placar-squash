//
//  ViewController.h
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define configPlacarSquash @"data.plist"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate,UIActionSheetDelegate>{
    
    NSMutableArray *listaCategorias;
    NSMutableArray *listaRodadas;
    NSMutableArray *listaCampeonato;
    
    UIPickerView *picker;
    UIPickerView *pickerRodada;
    UIPickerView *pickerCampeonato;
    
    NSString *fotoDeQuem;
    
    int isNovoJogo;
}

@property (strong, nonatomic) IBOutlet UIButton *btLimparJogo;
@property (strong, nonatomic) IBOutlet UITextField *txCampeonato;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scGames;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scGenero;
@property (strong, nonatomic) IBOutlet UITextField *txCategoria;
@property (strong, nonatomic) IBOutlet UITextField *txJogador1;
@property (strong, nonatomic) IBOutlet UITextField *txJogador2;
@property (strong, nonatomic) IBOutlet UITextField *txNumeroCampeonato;

@property (strong, nonatomic) IBOutlet UIImageView *ivJogador1;
@property (strong, nonatomic) IBOutlet UIImageView *ivJogador2;

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btIniciar;
@property (strong, nonatomic) IBOutlet UITextField *txRodada;


- (IBAction)doneKeyboard:(id)sender;
- (IBAction)atcBtFotoJogador1:(id)sender;
- (IBAction)atcBtFotoJogador2:(id)sender;
- (IBAction)actBtLimparJogo:(id)sender;




@end
