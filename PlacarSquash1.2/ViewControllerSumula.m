//
//  ViewControllerSumula.m
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import "ViewControllerSumula.h"
#import "Persistencia.h"

@interface ViewControllerSumula ()

@end

@implementation ViewControllerSumula

@synthesize dpDatePickerData, dpDatePickerHora;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    tamanhoLinha = 25;
    
    [self setImageBackground:@"imgQuadraCortada.png"];
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"dd/MM/yyyy"];
    _txData.text = [dataFormatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *horaFormatter = [[NSDateFormatter alloc] init];
    [horaFormatter setDateFormat:@"hh:mm"];
    _txHora.text = [horaFormatter stringFromDate:[NSDate date]];
    [super viewDidLoad];
    [self preencheCampos];
}

-(void)preencheCampos{
    [self carregaBanco];
    
    if(!self.dadosJogo){
        return;
    }
    
    _txQuadra.text = self.dadosSumula.quadra;
    _txArbitro.text =self.dadosSumula.juiz;
    _txMarcador.text = self.dadosSumula.marcador;
}

-(void)salvarJogo:(DadosJogo*) dadosJogo{
    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
    [per salvar:dadosJogo];
    [per fechar];
    
    [self salvarDadosSumula];
}

-(void)salvarDadosSumula{
    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
    [per salvarDadosSumula:self.dadosSumula];
    [per fechar];
}

-(void)carregaBanco{
    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
    self.dadosSumula = [per consultarDadosSumula];
    [per fechar];
    
    if(!self.dadosSumula){
        self.dadosSumula = [[DadosSumula alloc] init];
        self.dadosSumula.idObjeto = 0;
        self.dadosSumula.quadra = @"";
        self.dadosSumula.marcador = @"";
        self.dadosSumula.juiz = @"";
    }
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)doneKeyboard:(id)sender{
    self.dadosSumula.quadra = _txQuadra.text;
    self.dadosSumula.juiz = _txArbitro.text;
    self.dadosSumula.marcador = _txMarcador.text;
    
    [self salvarDadosSumula];
    [sender resignFirstResponder];
}

- (void)enviarEmail:(NSString *)pdfFileName {
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        vc.mailComposeDelegate = self;
        [vc addAttachmentData:[NSData dataWithContentsOfFile:pdfFileName] mimeType:@"application/pdf" fileName:pdfFileName];
        
        NSString *emailBody = [[NSString alloc] initWithFormat:@"Segue a súmula em anexo do jogo entre %@ e %@", _dadosJogo.jogador1, _dadosJogo.jogador2 ];
        [vc setMessageBody:emailBody isHTML:NO];
        [vc setSubject:@"Súmula"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}

#pragma mark - mail compose delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        }
        case MFMailComposeResultSaved:
        {
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        }
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        }
        case MFMailComposeResultFailed:
        {
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        }
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)printPDF:(NSString *)pdfFileName {
    UIPrintInteractionController *printer=[UIPrintInteractionController sharedPrintController];
    UIPrintInfo *info = [UIPrintInfo printInfo];
    info.orientation = UIPrintInfoOrientationPortrait;
    info.outputType = UIPrintInfoOutputGeneral;
    info.jobName=@"pdfFileName";
    info.duplex=UIPrintInfoDuplexLongEdge;
    printer.printInfo = info;
    printer.printingItem=[NSData dataWithContentsOfFile:pdfFileName];
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
        if (!completed && error)
            NSLog(@"FAILED! error = %@",[error localizedDescription]);
    };
    [printer presentAnimated:YES completionHandler:completionHandler];
}


- (void)escreverArquivoEnviarImprimir:(BOOL)imprimir {
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *pdfFileName = [documentDirectory stringByAppendingPathComponent:@"mypdf.pdf"];
    
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    NSString *myString = @"Súmula de Squash";
    
    
    [myString drawAtPoint:CGPointMake(220, 10) withAttributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:20] }];
    
    [self constroiLinha:2 pontoInicial:10 tamanho:100 texto:_txData.text titulo:@"Date"];
    [self constroiLinha:3 pontoInicial:10 tamanho:100 texto:_txHora.text titulo:@"Time"];
    [self constroiLinha:4 pontoInicial:10 tamanho:100 texto:_txQuadra.text titulo:@"Court"];
    
    [self constroiLinha:1 pontoInicial:110 tamanho:230 texto:_dadosJogo.campeonato titulo:@"Event"];
    [self constroiLinha:2 pontoInicial:110 tamanho:230 texto:_dadosJogo.jogador1 titulo:@"A:"];
    [self constroiLinha:3 pontoInicial:110 tamanho:230 texto:_dadosJogo.jogador2 titulo:@"B:"];
    [self constroiLinha:4 pontoInicial:110 tamanho:130 texto:_txArbitro.text titulo:@"Referee"];
    
    [self constroiLinha:4 pontoInicial:240 tamanho:100 texto:@"" titulo:@"Signature"];
    
    
    [self constroiLinha:1 pontoInicial:340 tamanho:200 texto:@"" titulo:@"Draw"];
    [self constroiLinha:1 pontoInicial:540 tamanho:60 texto:@"" titulo:@"Match Nr"];
    
    int inicioPontos = 340;
    [self constroiLinha:2 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.totalJ1G1 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:2 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.totalJ1G2 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:2 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.totalJ1G3 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:2 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.totalJ1G4 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:2 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.totalJ1G5 titulo:@""];
    
    [self constroiLinha:2 pontoInicial:540 tamanho:60 texto:_dadosJogo.totalGames1 titulo:@""];
    
    inicioPontos = 340;
    [self constroiLinha:3 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.total21G1 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:3 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.total21G2 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:3 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.total21G3 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:3 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.total21G4 titulo:@""];
    inicioPontos +=40;
    [self constroiLinha:3 pontoInicial:inicioPontos tamanho:40 texto:_dadosJogo.total21G5 titulo:@""];
    
    [self constroiLinha:3 pontoInicial:540 tamanho:60 texto:_dadosJogo.totalGames2 titulo:@""];
    
    [self constroiLinha:4 pontoInicial:340 tamanho:100 texto:_txMarcador.text titulo:@"Marker"];
    [self constroiLinha:4 pontoInicial:440 tamanho:100 texto:@"" titulo:@"Signature"];
    
    [self constroiLinha:4 pontoInicial:540 tamanho:60 texto:[self getDuracaoJogo] titulo:@"Duration"];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *dtIG1 = [formatter stringFromDate:_dadosJogo.dtInicioG1];
    NSString *dtIG2 = [formatter stringFromDate:_dadosJogo.dtInicioG2];
    NSString *dtIG3 = [formatter stringFromDate:_dadosJogo.dtInicioG3];
    NSString *dtIG4 = [formatter stringFromDate:_dadosJogo.dtInicioG4];
    NSString *dtIG5 = [formatter stringFromDate:_dadosJogo.dtInicioG5];
    
    NSString *dtFG1st = [formatter stringFromDate:_dadosJogo.dtFimG1];
    NSString *dtFG2st = [formatter stringFromDate:_dadosJogo.dtFimG2];
    NSString *dtFG3st = [formatter stringFromDate:_dadosJogo.dtFimG3];
    NSString *dtFG4st = [formatter stringFromDate:_dadosJogo.dtFimG4];
    NSString *dtFG5st = [formatter stringFromDate:_dadosJogo.dtFimG5];
    
    dtFG1st = (dtFG1st != nil ? dtFG1st : @"");
    dtFG2st = (dtFG2st != nil ? dtFG2st : @"");
    dtFG3st = (dtFG3st != nil ? dtFG3st : @"");
    dtFG4st = (dtFG4st != nil ? dtFG4st : @"");
    dtFG5st = (dtFG5st != nil ? dtFG5st : @"");
    
    NSString *dtFG1 = [[NSString alloc]initWithFormat:@"       %@", dtFG1st];
    NSString *dtFG2 = [[NSString alloc]initWithFormat:@"       %@", dtFG2st];
    NSString *dtFG3 = [[NSString alloc]initWithFormat:@"       %@", dtFG3st];
    NSString *dtFG4 = [[NSString alloc]initWithFormat:@"       %@", dtFG4st];
    NSString *dtFG5 = [[NSString alloc]initWithFormat:@"       %@", dtFG5st];
    
    NSString *resultadoG1 = [[NSString alloc]initWithFormat:@"%@ - %@", _dadosJogo.totalJ1G1, _dadosJogo.total21G1];
    NSString *resultadoG2 = [[NSString alloc]initWithFormat:@"%@ - %@", _dadosJogo.totalJ1G2, _dadosJogo.total21G2];
    NSString *resultadoG3 = [[NSString alloc]initWithFormat:@"%@ - %@", _dadosJogo.totalJ1G3, _dadosJogo.total21G3];
    NSString *resultadoG4 = [[NSString alloc]initWithFormat:@"%@ - %@", _dadosJogo.totalJ1G4, _dadosJogo.total21G4];
    NSString *resultadoG5 = [[NSString alloc]initWithFormat:@"%@ - %@", _dadosJogo.totalJ1G5, _dadosJogo.total21G5];
    
    // 1º Game
    int pontoInicial = 10;
    int tamanhoColuna = 59;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtIG1 titulo:@"Start"];
    [self constroiLinha:7 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:@"         1st game" titulo:@""];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"A:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    [self constroiLinha:28 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:_dadosJogo.vencedorG1 titulo:@"Winner:"];
    [self constroiLinha:29 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:resultadoG1 titulo:@"Result:"];
    
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtFG1 titulo:@"               Finish"];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"B:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    
    // 2º Game
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtIG2 titulo:@"Start"];
    [self constroiLinha:7 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:@"         2nd game" titulo:@""];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"A:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    [self constroiLinha:28 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:_dadosJogo.vencedorG2 titulo:@"Winner:"];
    [self constroiLinha:29 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:resultadoG2 titulo:@"Result:"];
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtFG2 titulo:@"               Finish"];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"B:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    
    // 3º Game
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtIG3 titulo:@"Start"];
    [self constroiLinha:7 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:@"         3rd game" titulo:@""];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"A:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    [self constroiLinha:28 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:_dadosJogo.vencedorG3  titulo:@"Winner:"];
    [self constroiLinha:29 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:resultadoG3 titulo:@"Result:"];
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtFG3 titulo:@"               Finish"];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"B:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    
    // 4º Game
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtIG4 titulo:@"Start"];
    [self constroiLinha:7 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:@"         4th game" titulo:@""];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"A:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    [self constroiLinha:28 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:_dadosJogo.vencedorG4 titulo:@"Winner:"];
    [self constroiLinha:29 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:resultadoG4 titulo:@"Result:"];
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtFG4 titulo:@"               Finish"];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"B:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    
    // 5º Game
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtIG5 titulo:@"Start"];
    [self constroiLinha:7 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:@"         5th game" titulo:@""];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"A:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    [self constroiLinha:28 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:_dadosJogo.vencedorG5 titulo:@"Winner:"];
    [self constroiLinha:29 pontoInicial:pontoInicial tamanho:tamanhoColuna*2 texto:resultadoG5 titulo:@"Result:"];
    pontoInicial += tamanhoColuna;
    [self constroiLinha:6 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:dtFG5 titulo:@"               Finish"];
    [self constroiLinha:8 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@"B:"];
    [self constroiRetangulo:9 pontoInicial:pontoInicial tamanho:tamanhoColuna texto:@"" titulo:@""];
    
    // Constroi pontuação
    int linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame1Jogador1) {
        [self constroiLinhaResultado:linhaResultado coluna:0 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame1Jogador2) {
        [self constroiLinhaResultado:linhaResultado coluna:1 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame2Jogador1) {
        [self constroiLinhaResultado:linhaResultado coluna:2 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame2Jogador2) {
        [self constroiLinhaResultado:linhaResultado coluna:3 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame3Jogador1) {
        [self constroiLinhaResultado:linhaResultado coluna:4 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame3Jogador2) {
        [self constroiLinhaResultado:linhaResultado coluna:5 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame4Jogador1) {
        [self constroiLinhaResultado:linhaResultado coluna:6 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame4Jogador2) {
        [self constroiLinhaResultado:linhaResultado coluna:7 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame5Jogador1) {
        [self constroiLinhaResultado:linhaResultado coluna:8 valor:ponto];
        linhaResultado++;
    }
    
    linhaResultado = 1;
    for (NSString *ponto in _dadosJogo.pontosGame5Jogador2) {
        [self constroiLinhaResultado:linhaResultado coluna:9 valor:ponto];
        linhaResultado++;
    }
    
    UIGraphicsEndPDFContext();
    
    if(imprimir){
        [self printPDF:pdfFileName];
    } else {
        [self enviarEmail:pdfFileName];
    }
}

-(NSString *)getDuracaoJogo{
    
    NSString *retorno = [[NSString alloc]init];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    NSString *dateString = @"01-01-2014 00:00:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *dateSinceDuration = [[NSDate alloc] init];
    dateSinceDuration = [dateFormatter dateFromString:dateString];
    
    if(_dadosJogo.dtFimG5 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG5 timeIntervalSinceDate: _dadosJogo.dtInicioG1];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        retorno = [formatter stringFromDate:endDate];
        
    } else if(_dadosJogo.dtFimG4 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG4 timeIntervalSinceDate: _dadosJogo.dtInicioG1];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        retorno = [formatter stringFromDate:endDate];
        
    } else if(_dadosJogo.dtFimG3 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG3 timeIntervalSinceDate: _dadosJogo.dtInicioG1];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        retorno = [formatter stringFromDate:endDate];
        
    } else if(_dadosJogo.dtFimG2 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG2 timeIntervalSinceDate: _dadosJogo.dtInicioG1];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        retorno = [formatter stringFromDate:endDate];
        
    } else if(_dadosJogo.dtFimG1 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG1 timeIntervalSinceDate: _dadosJogo.dtInicioG1];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        retorno = [formatter stringFromDate:endDate];
        
    }
    
    return retorno;
}

-(void)constroiLinha:(int)linha pontoInicial:(int)pontoInicial tamanho:(int)tamanho texto:(NSString *)texto titulo:(NSString *)titulo {
    int y_minimo = 30;
    int y_linha = linha * tamanhoLinha;
    y_linha += y_minimo;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:12] };
    NSDictionary *attributesTitles = @{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:8] };
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
    drawingContext.minimumScaleFactor = 0.5;
    
    CGRect rectangle = CGRectMake(pontoInicial, y_linha, tamanho, tamanhoLinha);
    CGRect rectangleTexto = CGRectMake(pontoInicial+3, y_linha+tamanhoLinha -4, tamanho-6, tamanhoLinha);
    CGContextStrokeRect(context, rectangle);
    NSString *text = texto;
    NSString *textTitle = [[NSString alloc]initWithFormat:@" %@", titulo];
    [textTitle drawWithRect:rectangle options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesTitles context:drawingContext];
    
    [text drawWithRect:rectangleTexto options:NSStringDrawingUsesFontLeading attributes:attributes context:drawingContext];
}

-(void)constroiRetangulo:(int)linha pontoInicial:(int)pontoInicial tamanho:(int)tamanho texto:(NSString *)texto titulo:(NSString *)titulo {
    int y_minimo = 30;
    int y_linha = linha * tamanhoLinha;
    y_linha += y_minimo;
    
    NSDictionary *attributesTitles = @{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:8] };
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
    drawingContext.minimumScaleFactor = 0.5;
    
    CGRect rectangle = CGRectMake(pontoInicial, y_linha, tamanho, (tamanhoLinha*19));
    
    CGContextStrokeRect(context, rectangle);
    NSString *textTitle = [[NSString alloc]initWithFormat:@" %@", titulo];
    [textTitle drawWithRect:rectangle options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesTitles context:drawingContext];
    
}

-(void)constroiLinhaResultado:(int)linha coluna:(int)coluna valor:(NSString *)valor{
    int tamanhoLinhaResultado = 15;
    int y_minimo = 30+(tamanhoLinha*8);
    int y_linha = linha * tamanhoLinhaResultado;
    y_linha += y_minimo;
    int tamanhoColuna = 59;
    int pontoInicial = 10 + (tamanhoColuna*coluna);
    
    NSStringDrawingContext *drawingContext = [[NSStringDrawingContext alloc] init];
    drawingContext.minimumScaleFactor = 0.5;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:10] };
    CGRect rectangleTexto = CGRectMake(pontoInicial+3, y_linha+tamanhoLinha -4, tamanhoColuna-6, tamanhoLinha);
    
    NSString *text = valor;
    
    [text drawWithRect:rectangleTexto options:NSStringDrawingUsesFontLeading attributes:attributes context:drawingContext];
}


- (IBAction)gerarPdfSumula:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"O que fazer?" message:@"" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Enviar por email", @"Imprimir via AirPrint", @"Limpar Tela", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet.title isEqualToString:@"O que fazer?"]){
        if (buttonIndex == 1){
            [self escreverArquivoEnviarImprimir:NO];
        } else if (buttonIndex == 2){
            [self escreverArquivoEnviarImprimir:YES];
        } else if (buttonIndex == 3){
            [self limparDadosSumula];
        }
    }
}
        
-(void)limparDadosSumula{
    self.dadosSumula.quadra = @"";
    self.dadosSumula.marcador = @"";
    self.dadosSumula.juiz = @"";
    
    _txQuadra.text =  @"";
    _txArbitro.text = @"";
    _txMarcador.text =  @"";
    _txData.text = @"";
    _txHora.text = @"";
    
    [self salvarDadosSumula];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_txData resignFirstResponder];
    [_txHora resignFirstResponder];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if([textField isEqual:_txData]){
        [self txDataClicked:textField];
    } else  if([textField isEqual:_txHora]){
        [self txHoraClicked:textField];
    }
}

- (IBAction)txDataClicked:(id)sender
{
    dpDatePickerData = [[UIDatePicker alloc] init];
    dpDatePickerData.datePickerMode = UIDatePickerModeDate;
    [dpDatePickerData addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    dpDatePickerData.timeZone = [NSTimeZone defaultTimeZone];
    dpDatePickerData.minuteInterval = 5;
    
    [_txData setInputView:dpDatePickerData];
}

- (void)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    _txData.text = [dateFormatter stringFromDate:dpDatePickerData.date];
}

- (IBAction)txHoraClicked:(id)sender{
    dpDatePickerHora = [[UIDatePicker alloc] init];
    dpDatePickerHora.datePickerMode = UIDatePickerModeTime;
    [dpDatePickerHora addTarget:self action:@selector(datePickerHoraValueChanged:) forControlEvents:UIControlEventValueChanged];
    dpDatePickerHora.timeZone = [NSTimeZone defaultTimeZone];
    dpDatePickerHora.minuteInterval = 1;
    
    [_txHora setInputView:dpDatePickerHora];
}

- (void)datePickerHoraValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm"];
    _txHora.text = [dateFormatter stringFromDate:dpDatePickerHora.date];
}

@end
