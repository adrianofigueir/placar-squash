//
//  ViewController.m
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerJogo.h"
#import "DadosJogo.h"
#import "DadosGame.h"
#import "Persistencia.h"

@class Persistencia;

@interface ViewController ()
@property (strong, nonatomic) UIWindow *secondWindow;
@property (strong, nonatomic) DadosJogo *dadosJogo;
@property (strong, nonatomic) UIImage *fotoJogador1;
@property (strong, nonatomic) UIImage *fotoJogador2;
@property (strong, nonatomic) IBOutlet UIImageView *ivMomento;
@property (strong, nonatomic) IBOutlet UIActionSheet *actionSheetTela;

@end

@implementation ViewController
@synthesize actionSheetTela;
@synthesize imagePicker;
@synthesize ivMomento;
@synthesize txCategoria, txRodada, txCampeonato;
@synthesize ivJogador1, ivJogador2;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self setImageBackground: @"imgQuadraCortada.png"];
    
    fotoDeQuem = [[NSString alloc]init];
    
    listaCampeonato = [[NSMutableArray alloc]init];
    [listaCampeonato addObject:@"Campeonato Brasileiro"];
    [listaCampeonato addObject:@"Iate Open de Squash"];
    [listaCampeonato addObject:@"Campeonato Interno"];
    
    listaCategorias = [[NSMutableArray alloc]init];
    [listaCategorias addObject:@"1ª Classe"];
    [listaCategorias addObject:@"2ª Classe"];
    [listaCategorias addObject:@"3ª Classe"];
    [listaCategorias addObject:@"4ª Classe"];
    [listaCategorias addObject:@"5ª Classe"];
    [listaCategorias addObject:@"6ª Classe"];
    [listaCategorias addObject:@"Principiante"];
    [listaCategorias addObject:@"Profissional"];
    [listaCategorias addObject:@"Profissional Dupla"];
    [listaCategorias addObject:@"Profissional Dupla Mista"];
    [listaCategorias addObject:@"Juvenil Dupla"];
    [listaCategorias addObject:@"Juvenil Dupla Mista"];
    [listaCategorias addObject:@"Juvenil sub-9"];
    [listaCategorias addObject:@"Juvenil sub-11"];
    [listaCategorias addObject:@"Juvenil sub-13"];
    [listaCategorias addObject:@"Juvenil sub-15"];
    [listaCategorias addObject:@"Juvenil sub-17"];
    [listaCategorias addObject:@"Juvenil sub-19"];
    [listaCategorias addObject:@"Juvenil sub-23"];
    [listaCategorias addObject:@"Master 23+A"];
    [listaCategorias addObject:@"Master 23+B"];
    [listaCategorias addObject:@"Master 23+C"];
    [listaCategorias addObject:@"Master 30+A"];
    [listaCategorias addObject:@"Master 30+B"];
    [listaCategorias addObject:@"Master 30+C"];
    [listaCategorias addObject:@"Master 35+A"];
    [listaCategorias addObject:@"Master 35+B"];
    [listaCategorias addObject:@"Master 35+C"];
    [listaCategorias addObject:@"Master 40+A"];
    [listaCategorias addObject:@"Master 40+B"];
    [listaCategorias addObject:@"Master 40+C"];
    [listaCategorias addObject:@"Master 45+A"];
    [listaCategorias addObject:@"Master 45+B"];
    [listaCategorias addObject:@"Master 45+C"];
    [listaCategorias addObject:@"Master 50+A"];
    [listaCategorias addObject:@"Master 50+B"];
    [listaCategorias addObject:@"Master 50+C"];
    [listaCategorias addObject:@"Master 55+A"];
    [listaCategorias addObject:@"Master 55+B"];
    [listaCategorias addObject:@"Master 55+C"];
    [listaCategorias addObject:@"Master 60+A"];
    [listaCategorias addObject:@"Master 60+B"];
    [listaCategorias addObject:@"Master 60+C"];
    [listaCategorias addObject:@"Master 65+A"];
    [listaCategorias addObject:@"Master 65+B"];
    [listaCategorias addObject:@"Master 65+C"];
    [listaCategorias addObject:@"Master 70+A"];
    [listaCategorias addObject:@"Master 70+B"];
    [listaCategorias addObject:@"Master 70+C"];
    [listaCategorias addObject:@"Master A"];
    [listaCategorias addObject:@"Master B"];
    [listaCategorias addObject:@"Master C"];
    [listaCategorias addObject:@"Master D"];
    [listaCategorias addObject:@"Master E"];
    [listaCategorias addObject:@"A"];
    [listaCategorias addObject:@"B"];
    [listaCategorias addObject:@"C"];
    [listaCategorias addObject:@"D"];
    [listaCategorias addObject:@"E"];
    
    listaRodadas = [[NSMutableArray alloc]init];
    [listaRodadas addObject:@"1ª Rodada"];
    [listaRodadas addObject:@"2ª Rodada"];
    [listaRodadas addObject:@"3ª Rodada"];
    [listaRodadas addObject:@"4ª Rodada"];
    [listaRodadas addObject:@"Quartas de Final"];
    [listaRodadas addObject:@"Semifinal"];
    [listaRodadas addObject:@"Final"];

    txCategoria.delegate = self;
    txRodada.delegate = self;
    //txCampeonato.delegate = self;
  
    _dadosJogo = [[DadosJogo alloc]init];
    [self preencheCampos];
    
    [self checkForExistingScreenAndInitializeIfPresent];

}
-(IBAction)actBtLimparJogo:(id)sender{
    [self excluirJogo:_dadosJogo];
    [self limpaCamposTela];
}

-(void)limpaCamposTela{
    txCategoria.text = @"";
    txRodada.text =@"";
    _txJogador1.text = @"";
    _txJogador2.text=@"";
    _scGames.selectedSegmentIndex = 1;
    ivJogador1.image=self.dadosJogo.imgJogador1;
    ivJogador2.image=self.dadosJogo.imgJogador2;
//    _txNumeroCampeonato.text = @"";
//    txCampeonato.text = @"";
    _scGenero.selectedSegmentIndex = 0;
}

-(void)preencheCampos{
    [self carregaBanco];
 
    if(!self.dadosJogo){
        return;
    }
    
    txCategoria.text = self.dadosJogo.categoria;
    txRodada.text =self.dadosJogo.rodada;
    _txJogador1.text = self.dadosJogo.jogador1;
    _txJogador2.text=self.dadosJogo.jogador2;
    
    if(self.dadosJogo.qtdGames == 3){
        _scGames.selectedSegmentIndex = 0;
    } else {
        _scGames.selectedSegmentIndex = 1;
    }
    
    if(self.dadosJogo.imgJogador1){
        ivJogador1.image=self.dadosJogo.imgJogador1;
    }
    
    if(self.dadosJogo.imgJogador2){
        ivJogador2.image=self.dadosJogo.imgJogador2;
    }
    
    _txNumeroCampeonato.text = self.dadosJogo.numeroCampeonato;
   
    if([self.dadosJogo.campeonato length] >4){
        txCampeonato.text = [self.dadosJogo.campeonato substringFromIndex:([self.dadosJogo.numeroCampeonato length]+4)];
    }
    
    if([self.dadosJogo.genero  isEqual: @"M"]){
        _scGenero.selectedSegmentIndex = 0;
    } else {
        _scGenero.selectedSegmentIndex = 1;
    }
    
}
-(void)salvarJogo:(DadosJogo*) dadosJogo{
    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
    [per salvar:dadosJogo];
    [per salvarFotos:dadosJogo];
    [per fechar];
}

-(void)excluirJogo:(DadosJogo*) dadosJogo{
    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
    [per deletar:_dadosJogo];
    [per deletarFotos:_dadosJogo];
    [per fechar];
    
    [self carregaBanco];
}

-(void)carregaBanco{

    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
   
    NSMutableArray *dados =[per consultar:self.dadosJogo];
    self.dadosJogo = [[DadosJogo alloc] init];
    self.dadosJogo = [dados lastObject];
    self.dadosJogo = [per consultarFotos: self.dadosJogo];
    [per fechar];
   
}

-(void)setImageBackground:(NSString*)imageName{
    UINavigationController* navigationController = [self navigationController];
    float height = navigationController.toolbar.frame.size.height;
    CGSize size = self.view.frame.size;
    size.height = size.height;
    UIGraphicsBeginImageContext(size);
    CGRect bounds = self.view.bounds;
    bounds.origin.y = bounds.origin.y + height;
    bounds.size.height = bounds.size.height-height;
    [[UIImage imageNamed:imageName] drawInRect:bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if([textField isEqual:txRodada]){

        UIView *pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 260)];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,215, [UIScreen mainScreen].bounds.size.width, 44)];
        [toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(fechaPk)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:flexible,flexible,doneButton, nil]];
        //
        CGRect pickerFrame = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, pickerBackView.frame.size.height);
        pickerRodada = [[UIPickerView alloc]initWithFrame:pickerFrame];
        txRodada.text = [listaRodadas objectAtIndex: 0];
        pickerRodada.delegate = self;
        //
        [pickerBackView addSubview:pickerRodada];
        [pickerBackView addSubview:toolBar];
        
         txRodada.inputView = pickerBackView;
    
    } else if([textField isEqual:txCampeonato]){
        CGRect pickerFrame = CGRectMake(0, 44, 0, 0);
        pickerCampeonato = [[UIPickerView alloc]initWithFrame:pickerFrame];
        txCampeonato.text = [listaCampeonato objectAtIndex: 0];
        txCampeonato.inputView = pickerCampeonato;
        pickerCampeonato.delegate = self;
        
    
    } else {
        UIView *pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 260)];
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,215, [UIScreen mainScreen].bounds.size.width, 44)];
        [toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [toolBar setShadowImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(fechaPk)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [toolBar setItems:[NSArray arrayWithObjects:flexible,flexible,doneButton, nil]];
        //
        CGRect pickerFrame = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, pickerBackView.frame.size.height);
        picker = [[UIPickerView alloc]initWithFrame:pickerFrame];
        txCategoria.text = [listaCategorias objectAtIndex: 0];
        picker.delegate = self;
        //
        [pickerBackView addSubview:picker];
        [pickerBackView addSubview:toolBar];
        txCategoria.inputView = pickerBackView;
    }
   
}
-(void)fechaPk{
    [txCategoria resignFirstResponder];
    [txRodada resignFirstResponder];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [txCategoria resignFirstResponder];
    [txRodada resignFirstResponder];
    [txCampeonato resignFirstResponder];
}

#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual:(pickerRodada)]){
        return [listaRodadas count];
        
    } else if([pickerView isEqual:(pickerCampeonato)]){
        return [listaCampeonato count];
        
    } else {
        return [listaCategorias count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:(pickerRodada)]){
        return [listaRodadas objectAtIndex:row];
        
    } else if([pickerView isEqual:(pickerCampeonato)]){
        return [listaCampeonato objectAtIndex:row];
        
    } else {
        return [listaCategorias objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if([pickerView isEqual:(pickerRodada)]){
        txRodada.text = [listaRodadas objectAtIndex:row];
    } else {
        txCategoria.text = [listaCategorias objectAtIndex:row];
        
    }
}

- (IBAction)doneKeyboard:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)atcBtFotoJogador1:(id)sender {
    ivMomento = ivJogador1;
    fotoDeQuem = @"1";
    imagePicker = [[UIImagePickerController alloc] init];
    
    UIImagePickerControllerSourceType sourceTypeFoto = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sourceTypeFoto = UIImagePickerControllerSourceTypeCamera;
    }
    
    imagePicker.sourceType = sourceTypeFoto;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)atcBtFotoJogador2:(id)sender {
    ivMomento = ivJogador2;
    fotoDeQuem = @"2";
    imagePicker = [[UIImagePickerController alloc] init];
    
    UIImagePickerControllerSourceType sourceTypeFoto = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sourceTypeFoto = UIImagePickerControllerSourceTypeCamera;
    }
    
    imagePicker.sourceType =  sourceTypeFoto;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Image Picker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    ivMomento.image = image;
    
    if([fotoDeQuem isEqualToString:@"1"]){
        _dadosJogo.imgJogador1 = image;
    } else {
        _dadosJogo.imgJogador2 = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if(self.dadosJogo == nil){
        self.dadosJogo = [[DadosJogo alloc]init];
    }
    
    self.dadosJogo.idObjeto = 1;
    
    if([txCategoria.text isEqualToString:@""]){
        self.dadosJogo.categoria = @"Sem categoria";
    } else {
        self.dadosJogo.categoria = txCategoria.text;
    }
    
    if([txRodada.text isEqualToString:@""]){
        self.dadosJogo.rodada = @"";
    } else {
        self.dadosJogo.rodada = txRodada.text;
    }
    
    if([_txJogador1.text isEqualToString:@""]){
        self.dadosJogo.jogador1 = @"Sem nome 1";
    } else {
        self.dadosJogo.jogador1 = _txJogador1.text;
    }
    
    if([_txJogador2.text isEqualToString:@""]){
        self.dadosJogo.jogador2 = @"Sem nome 2";
    } else {
        self.dadosJogo.jogador2 = _txJogador2.text;
    }
    
    if(_scGames.selectedSegmentIndex == 0){
        self.dadosJogo.qtdGames = 3;
    } else {
        self.dadosJogo.qtdGames = 5;
    }
    
    if([txCampeonato.text isEqualToString:@""]){
        self.dadosJogo.campeonato = @"";
    
    } else if([_txNumeroCampeonato.text isEqualToString:@""]){
        self.dadosJogo.campeonato = [NSString stringWithFormat:@"%@", txCampeonato.text];
    
    } else {
        if(![txCampeonato.text containsString:@"º"]){
            self.dadosJogo.campeonato = [NSString stringWithFormat:@"%@º - %@", _txNumeroCampeonato.text, txCampeonato.text];
        } else {
            self.dadosJogo.campeonato = [NSString stringWithFormat:@"%@ - %@", _txNumeroCampeonato.text, txCampeonato.text];
        }
    }
    
    self.dadosJogo.numeroCampeonato = _txNumeroCampeonato.text;
    if(ivJogador1.image){
        self.dadosJogo.imgJogador1 = ivJogador1.image;
    }
    if (ivJogador2.image) {
        self.dadosJogo.imgJogador2 = ivJogador2.image;
    }
    
    self.dadosJogo.idObjeto = -1;
    
    if([_txNumeroCampeonato.text isEqualToString:@""]){
        self.dadosJogo.categoria = @"";
    } else {
        self.dadosJogo.categoria = txCategoria.text;
    }
    
    if([txCategoria.text containsString:@"Mista"] || [txCategoria.text containsString:@"Misto"]){
        self.dadosJogo.genero = @"";
    } else if(_scGenero.selectedSegmentIndex == 0){
        self.dadosJogo.genero = @"M";
    } else {
        self.dadosJogo.genero = @"F";
    }
    
    //Salvar
    NSLog(@"SALVANDO DadosJogo");
    [self salvarJogo:self.dadosJogo];
    
    
    if([segue.identifier isEqualToString:@"telaJogo"]){
        NSLog(@"ENCAMINHANDO DadosJogo");
        ViewControllerJogo *jogo = segue.destinationViewController;
        jogo.dadosJogo = self.dadosJogo;
    }
}
-(void) mostraAlertViewComTitulo:(NSString*)titulo eMensagem:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:msg delegate:nil
    cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)checkForExistingScreenAndInitializeIfPresent
{
    if ([[UIScreen screens] count] > 1) {
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        CGRect screenBounds = secondScreen.bounds;
        self.secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.secondWindow.screen = secondScreen;
        
        UIGraphicsBeginImageContext(secondScreen.bounds.size);
        UIImage *imagemFundo = [UIImage imageNamed:@"imgLaunch_1024_x_768.png"];
        [imagemFundo drawInRect:CGRectMake(0, 0, secondScreen.bounds.size.width, secondScreen.bounds.size.height)];
        UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect subViewTelaoFrame = secondScreen.bounds;
        UIView *subViewTelao = [[UIView alloc] initWithFrame:subViewTelaoFrame];
        [subViewTelao setOpaque:NO];
        subViewTelao.backgroundColor=[UIColor colorWithPatternImage: destImage];
        [self.secondWindow addSubview:subViewTelao];
        self.secondWindow.hidden = NO;
    }
}


@end
