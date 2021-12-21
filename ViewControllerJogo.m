//
//  ViewControllerJogo.m
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import "ViewControllerJogo.h"
#import "Persistencia.h"

@interface ViewControllerJogo ()
@property (strong, nonatomic) UIWindow *secondWindow;
@property (strong, nonatomic) NSString *codigoHtml;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *uiViewEsquerdo;
@property (strong, nonatomic) UIView *uiViewDireito;
@property (strong, nonatomic) NSTimer *myTimer;

@end

@implementation ViewControllerJogo
@synthesize webView, uiViewDireito, uiViewEsquerdo;
@synthesize myTimer;

- (void)viewDidLoad
{
    NSLog(@"Entrou no ViewControllerJogo");
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
 
    [self setImageBackground:@"imgQuadraCortada.png"];

    segundosItervalo = 0;
    gamesJogador1 = 0;
    gamesJogador2 = 0;
    isMostrouTempo300 = NO;
    isPerguntarLadoSaque = NO;
    
    fimJogo = NO;
    iniciarNovoGame = NO;
    
    tituloExcecoes = @"Reconfigure o jogo.";
    tituloLadoSaque = @"Qual o lado do saque?";
    tituloQuemSaca = @"Quem saca?";
    
    if([_dadosJogo.genero isEqualToString:@"M"]){
        _lbCategoria.text = [NSString stringWithFormat:@"%@ - %@", _dadosJogo.categoria, @"Masculino"];
        
    } else if([_dadosJogo.genero isEqualToString:@"F"]){
        _lbCategoria.text =  [NSString stringWithFormat:@"%@ - %@", _dadosJogo.categoria, @"Feminino"];
    
    } else {
         _lbCategoria.text =  [NSString stringWithFormat:@"%@", _dadosJogo.categoria];
    }
    
    _lbJogador1.text = _dadosJogo.jogador1;
    _lbJogador2.text =  _dadosJogo.jogador2;
    _lbJogador1Placar.text = _dadosJogo.jogador1;
    _lbJogador2Placar.text =  _dadosJogo.jogador2;
    
    ultimoASacar = [[NSString alloc]init];

    _dadosJogo.pontosGame1Jogador1 = _dadosJogo.pontosGame1Jogador1 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame1Jogador1;
    
    _dadosJogo.pontosGame1Jogador2 = _dadosJogo.pontosGame1Jogador2 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame1Jogador2;
   
    _dadosJogo.pontosGame2Jogador1 = _dadosJogo.pontosGame2Jogador1 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame2Jogador1;
    
    _dadosJogo.pontosGame2Jogador2 = _dadosJogo.pontosGame2Jogador2 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame2Jogador2;
   
    _dadosJogo.pontosGame3Jogador1 = _dadosJogo.pontosGame3Jogador1 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame3Jogador1;
    
    _dadosJogo.pontosGame3Jogador2 = _dadosJogo.pontosGame3Jogador2 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame3Jogador2;
    
    _dadosJogo.pontosGame4Jogador1 = _dadosJogo.pontosGame4Jogador1 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame4Jogador1;
    
    _dadosJogo.pontosGame4Jogador2 = _dadosJogo.pontosGame4Jogador2 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame4Jogador2;
    
    _dadosJogo.pontosGame5Jogador1 = _dadosJogo.pontosGame5Jogador1 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame5Jogador1;
    
    _dadosJogo.pontosGame5Jogador2 = _dadosJogo.pontosGame5Jogador2 == NULL ? [[NSMutableArray alloc]init]: _dadosJogo.pontosGame5Jogador2;
    
    _dadosJogo.vencedorG1 = @"";
    _dadosJogo.vencedorG2 = @"";
    _dadosJogo.vencedorG3 = @"";
    _dadosJogo.vencedorG4 = @"";
    _dadosJogo.vencedorG5 = @"";
    
    NSLog(@"PREENCHENDO CAMPOS");
    //
    [self preencheCampos];
    NSLog(@"%d",_dadosJogo.qtdGames);
    
    if(_dadosJogo.qtdGames < 4){
        _lbJogador1Game4.text = @"-";
        _lbJogador2Game4.text = @"-";
        _lbJogador1Game5.text = @"-";
        _lbJogador2Game5.text = @"-";
    }
    
    NSLog(@"CONTRUINDO SEGUNDA TELA");
    [self reconectarPlacar];
    
    [self exibirTimmerCalculado];
    
}

-(Boolean)isJogoFinalizado{
    Boolean fim = FALSE;
    int pontosJogador1 = _btPontosJogador1.value;
    int pontosJogador2 = _btPontosJogador2.value;
    
    if(pontosJogador1 >= 11 || pontosJogador2 >= 11){
        if([_dadosJogo.categoria containsString: @"Dupla"]){
            
            if(pontosJogador1 > pontosJogador2){
                fim = gamesJogador1 > (_dadosJogo.qtdGames/2);
            } else if(pontosJogador2 > pontosJogador1){
                fim = gamesJogador2 > (_dadosJogo.qtdGames/2);
            }
        } else {
            if((pontosJogador1 - pontosJogador2) >= 2){
                fim = gamesJogador1 > (_dadosJogo.qtdGames/2);
            } else if((pontosJogador2 - pontosJogador1) >= 2){
                fim = gamesJogador2 > (_dadosJogo.qtdGames/2);
            }
        }
    }
    
    return fim;
}

-(void)exibirTimmerCalculado{
    if([self isJogoFinalizado]){
        [self fimDeJogo];

    } else {
        if(_dadosJogo.dtInicioG1 != NULL){
            if([_dadosJogo.categoria containsString:@"Profissional"]){
                [self exibirTimmer:120];
            } else {
                [self exibirTimmer:90];
            }
        
        } else {
            [self exibirTimmer:300];
        }
    }
}

-(void)preencheCampos{
    NSLog(@"PREENCHE CAMPOS");
    
    gamesJogador1 = [_dadosJogo.totalGames1 intValue];
    gamesJogador2 =[_dadosJogo.totalGames2 intValue];
    ultimoASacar =_dadosJogo.ultimoASacar;
    gameAtual =_dadosJogo.gameAtual;
    
    [self preenchePontosJogadores];
    
    NSString *valorGame = [[NSString alloc]initWithFormat:@"%iº Game", gameAtual];
    _lbGame.text = valorGame;
    
    [self atualizaBotaoPontosJogador];
    
    NSLog(@"FIM PREENCHE CAMPOS");
}
-(void)preenchePontosJogadores{
    _lbJogador1Game1.text = _dadosJogo.totalJ1G1 != nil ? _dadosJogo.totalJ1G1 : @"";
    _lbJogador2Game1.text = _dadosJogo.total21G1 != nil ? _dadosJogo.total21G1 : @"";
    
    _lbJogador1Game2.text = _dadosJogo.totalJ1G2 != nil ? _dadosJogo.totalJ1G2 : @"";
    _lbJogador2Game2.text = _dadosJogo.total21G2 != nil ? _dadosJogo.total21G2 : @"";
    
    _lbJogador1Game3.text = _dadosJogo.totalJ1G3 != nil ? _dadosJogo.totalJ1G3 : @"";
    _lbJogador2Game3.text = _dadosJogo.total21G3 != nil ? _dadosJogo.total21G3 : @"";
    
    _lbJogador1Game4.text = _dadosJogo.totalJ1G4 != nil ? _dadosJogo.totalJ1G4 : @"";
    _lbJogador2Game4.text = _dadosJogo.total21G4 != nil ? _dadosJogo.total21G4 : @"";
    
    _lbJogador1Game5.text = _dadosJogo.totalJ1G5 != nil ? _dadosJogo.totalJ1G5 : @"";
    _lbJogador2Game5.text = _dadosJogo.total21G5 != nil ? _dadosJogo.total21G5 : @"";
}

-(void)atualizaBotaoPontosJogador{
    
    if(gameAtual == 5){
        _btPontosJogador1.value = [_dadosJogo.totalJ1G5 intValue];
        _btPontosJogador2.value = [_dadosJogo.total21G5 intValue];
    
    } else if(gameAtual == 4){
        _btPontosJogador1.value = [_dadosJogo.totalJ1G4 intValue];
        _btPontosJogador2.value = [_dadosJogo.total21G4 intValue];
    
    } else if(gameAtual == 3){
        _btPontosJogador1.value = [_dadosJogo.totalJ1G3 intValue];
        _btPontosJogador2.value = [_dadosJogo.total21G3 intValue];
    
    } else if(gameAtual == 2){
        _btPontosJogador1.value = [_dadosJogo.totalJ1G2 intValue];
        _btPontosJogador2.value = [_dadosJogo.total21G2 intValue];
    
    } else if(gameAtual == 1){
        _btPontosJogador1.value = [_dadosJogo.totalJ1G1 intValue];
        _btPontosJogador2.value = [_dadosJogo.total21G1 intValue];
    
    } else {
        _btPontosJogador1.value = 0;
        _btPontosJogador2.value = 0;
    }
    
    _lbPontosJogador1.text = [NSString stringWithFormat:@"%d",(int)_btPontosJogador1.value];
    _lbPontosJogador2.text = [NSString stringWithFormat:@"%d",(int)_btPontosJogador2.value];
    
}

-(NSString*)getIntStrFromArray:(NSMutableArray*) arr{
    NSString *test =[NSString stringWithFormat:@"%@",arr.lastObject] ;
    NSString *strnum =[test substringToIndex:2];
    return strnum;
}

-(void)salvarJogo:(DadosJogo*) dadosJogo{
    [self atualizaTotais];
    
    NSLog(@"SALVANDO JOGO");
   _dadosJogo.ultimoASacar = ultimoASacar;
   _dadosJogo.gameAtual = gameAtual;
    
    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
    [per salvar:_dadosJogo];
    [per fechar];
}

-(void)excluirJogo:(DadosJogo*) dadosJogo{
    [_dadosJogo.pontosGame1Jogador1 removeAllObjects];
    [_dadosJogo.pontosGame2Jogador1 removeAllObjects];
    [_dadosJogo.pontosGame3Jogador1 removeAllObjects];
    [_dadosJogo.pontosGame4Jogador1 removeAllObjects];
    [_dadosJogo.pontosGame5Jogador1 removeAllObjects];
    [_dadosJogo.pontosGame1Jogador2 removeAllObjects];
    [_dadosJogo.pontosGame2Jogador2 removeAllObjects];
    [_dadosJogo.pontosGame3Jogador2 removeAllObjects];
    [_dadosJogo.pontosGame4Jogador2 removeAllObjects];
    [_dadosJogo.pontosGame5Jogador2 removeAllObjects];
    _dadosJogo.pontosGame1Jogador1 = nil;
    _dadosJogo.pontosGame2Jogador1 = nil;
    _dadosJogo.pontosGame3Jogador1 = nil;
    _dadosJogo.pontosGame4Jogador1 = nil;
    _dadosJogo.pontosGame5Jogador1 = nil;
    _dadosJogo.pontosGame1Jogador2 = nil;
    _dadosJogo.pontosGame2Jogador2 = nil;
    _dadosJogo.pontosGame3Jogador2 = nil;
    _dadosJogo.pontosGame4Jogador2 = nil;
    _dadosJogo.pontosGame5Jogador2 = nil;
    
    Persistencia *per = [[Persistencia alloc]init];
    [per abrir];
    [per deletar:_dadosJogo];
    [per deletarFotos:_dadosJogo];
    [per fechar];
    
    NSLog(@"Ecluiu o jogo!!");
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)actBtPontosJogador1:(id)sender {
    [self verificaPontuacao];
    
    if(!fimJogo && !iniciarNovoGame){
        if( [ultimoASacar isEqualToString:@"2"]){
            [self popupLadoSaque];
        } else {
            [self trocaLadoSaque];
        }
    }
    
    // Diminuindo pontos
    if(utlimaPontuacaoJogador1 > _btPontosJogador1.value){
        int valorMinimo = (int)_btPontosJogador2.value-1;
        if(valorMinimo <=0){
            valorMinimo = 0;
        }
        
        _btPontosJogador2.minimumValue = valorMinimo;
        [self delPontuacaoJogador1:gameAtual];
        
    } else { // Aumentando pontos
        ultimoAPontuar = 1;
        [self atualizaSacador:@"1"];
        _btPontosJogador2.minimumValue = _btPontosJogador2.value;
        
        if(!fimJogo && !iniciarNovoGame){
            [self addPontuacaoJogador1:[[NSString alloc]initWithFormat:@"%i %@", (int)_btPontosJogador1.value, ladoUltimoSaque]  game:gameAtual];
        }
        
    }
    
    _lbPontosJogador1.text = [[NSString alloc]initWithFormat:@"%i", (int)_btPontosJogador1.value];
    utlimaPontuacaoJogador1 = (int)_btPontosJogador1.value;
    
    [self atualizaTelao];
    [self verificaMatchGameBall:sender];
    
    [self salvarJogo:_dadosJogo];
}

- (IBAction)actBtPontosJogador2:(id)sender {
    [self verificaPontuacao];
    
    if(!fimJogo && !iniciarNovoGame){
        if( [ultimoASacar isEqualToString:@"1"]){
            [self popupLadoSaque];
        } else {
            [self trocaLadoSaque];
        }
    }

    if(utlimaPontuacaoJogador2 > _btPontosJogador2.value){
        int valorMinimo = (int)_btPontosJogador1.value-1;
        if(valorMinimo <=0){
            valorMinimo = 0;
        }
        _btPontosJogador1.minimumValue = valorMinimo;
        [self delPontuacaoJogador2:gameAtual];
    } else {
        ultimoAPontuar = 2;
        [self atualizaSacador:@"2"];
        _btPontosJogador1.minimumValue = _btPontosJogador1.value;
        if(!fimJogo && !iniciarNovoGame){
            [self addPontuacaoJogador2:[[NSString alloc]initWithFormat:@"%i %@", (int)_btPontosJogador2.value, ladoUltimoSaque]  game:gameAtual];
        }
    }
    
    _lbPontosJogador2.text = [[NSString alloc]initWithFormat:@"%i", (int)_btPontosJogador2.value];
    utlimaPontuacaoJogador2 = (int)_btPontosJogador2.value;
    [self atualizaTelao];
    [self verificaMatchGameBall:sender];
    
    [self salvarJogo:_dadosJogo];
}

-(IBAction)verificaMatchGameBall:(id)sender{
    if(!fimJogo){
        if(_btPontosJogador1.value >= 10 || _btPontosJogador2.value >= 10){
            if([_dadosJogo.categoria containsString:@"Dupla"]){
                if([self isGameBall]){
                    [self acionaGameBall];
                } else {
                    [self acionaMatch];
                }
            } else {
                if((_btPontosJogador1.value - _btPontosJogador2.value) >= 1 || (_btPontosJogador2.value - _btPontosJogador1.value) >= 1){
                    
                    if([self isMacthBallJogador1] || [self isMacthBallJogador2]){
                        [self acionaMatch];
                    
                    } else {
                        [self acionaGameBall];
                    }
                }
            }
        }
    }
}

-(BOOL)isGameBall{
    return !(gamesJogador1+1 > (_dadosJogo.qtdGames/2) || gamesJogador2+1 > (_dadosJogo.qtdGames/2));
}

-(BOOL)isMacthBallJogador1{
    return ((_btPontosJogador1.value >= 10) && ((_btPontosJogador1.value - _btPontosJogador2.value) >= 1) && (gamesJogador1+1 > (_dadosJogo.qtdGames/2)));
}

-(BOOL)isMacthBallJogador2{
    return ((_btPontosJogador2.value >= 10) && ((_btPontosJogador2.value - _btPontosJogador1.value) >= 1) && (gamesJogador2+1 > (_dadosJogo.qtdGames/2)));
}

-(void)atualizaTotais{
    _dadosJogo.totalJ1G1 = _lbJogador1Game1.text;
    _dadosJogo.totalJ1G2 = _lbJogador1Game2.text;
    _dadosJogo.totalJ1G3 = _lbJogador1Game3.text;
    _dadosJogo.totalJ1G4 = _lbJogador1Game4.text;
    _dadosJogo.totalJ1G5 = _lbJogador1Game5.text;
    _dadosJogo.total21G1 = _lbJogador2Game1.text;
    _dadosJogo.total21G2 = _lbJogador2Game2.text;
    _dadosJogo.total21G3 = _lbJogador2Game3.text;
    _dadosJogo.total21G4 = _lbJogador2Game4.text;
    _dadosJogo.total21G5 = _lbJogador2Game5.text;
    _dadosJogo.totalGames1 = [[NSString alloc] initWithFormat:@"%i", gamesJogador1];
    _dadosJogo.totalGames2 = [[NSString alloc] initWithFormat:@"%i", gamesJogador2];
}

-(void)addPontuacaoJogador1:(NSString *)valor game:(int)game{
    NSString *ponto = [[NSString alloc]initWithFormat:@"%@", valor];
     if(game == 1){
        [_dadosJogo.pontosGame1Jogador1 addObject:ponto];
    } else if(game == 2){
        [_dadosJogo.pontosGame2Jogador1 addObject:ponto];
    } else if(game == 3){
        [_dadosJogo.pontosGame3Jogador1 addObject:ponto];
    } else if(game == 4){
        [_dadosJogo.pontosGame4Jogador1 addObject:ponto];
    } else if(game == 5){
        [_dadosJogo.pontosGame5Jogador1 addObject:ponto];
    }
}
-(void)delPontuacaoJogador1:(int)game{
    if(game == 1){
        [_dadosJogo.pontosGame1Jogador1 removeLastObject];
    } else if(game == 2){
        [_dadosJogo.pontosGame2Jogador1 removeLastObject];
    } else if(game == 3){
        [_dadosJogo.pontosGame3Jogador1 removeLastObject];
    } else if(game == 4){
        [_dadosJogo.pontosGame4Jogador1 removeLastObject];
    } else if(game == 5){
        [_dadosJogo.pontosGame5Jogador1 removeLastObject];
    }
}
-(void)addPontuacaoJogador2:(NSString *)valor game:(int)game{
    NSString *ponto = [[NSString alloc]initWithFormat:@"%@", valor];
    if(game == 1){
        [_dadosJogo.pontosGame1Jogador2 addObject:ponto];
    } else if(game == 2){
        [_dadosJogo.pontosGame2Jogador2 addObject:ponto];
    } else if(game == 3){
        [_dadosJogo.pontosGame3Jogador2 addObject:ponto];
    } else if(game == 4){
        [_dadosJogo.pontosGame4Jogador2 addObject:ponto];
    } else if(game == 5){
        [_dadosJogo.pontosGame5Jogador2 addObject:ponto];
    }
}
-(void)delPontuacaoJogador2:(int)game{
    if(game == 1){
        [_dadosJogo.pontosGame1Jogador2 removeLastObject];
    } else if(game == 2){
        [_dadosJogo.pontosGame2Jogador2 removeLastObject];
    } else if(game == 3){
        [_dadosJogo.pontosGame3Jogador2 removeLastObject];
    } else if(game == 4){
        [_dadosJogo.pontosGame4Jogador2 removeLastObject];
    } else if(game == 5){
        [_dadosJogo.pontosGame5Jogador2 removeLastObject];
    }
}

-(void)delayBotaoPontos{
    _btPontosJogador1.hidden = YES;
    _btPontosJogador2.hidden = YES;
    
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        _btPontosJogador1.hidden = NO;
        _btPontosJogador2.hidden = NO;
    });
}

- (IBAction)acionaStroke:(id)sender {
    _telao_lbStroke.hidden = NO;
    _btStroke.backgroundColor = [UIColor redColor];
    [self sumirLetStroke];
}

- (IBAction)acionaLet:(id)sender {
    _telao_lbLet.hidden = NO;
    _btLet.backgroundColor = [UIColor redColor];
    [self sumirLetStroke];
}

- (IBAction)acionaMatch {
    _telao_lbMatch.hidden = NO;
    [self sumirLetStroke];
}

- (IBAction)acionaGameBall {
    _telao_lbGameBall.hidden = NO;
    [self sumirLetStroke];
}

- (IBAction)iniciarAgora:(id)sender {
    [self finalizaContagemTempo];
}

- (IBAction)actBtExcecao:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tituloExcecoes message:@"" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Selecionar o sacador", @"Selecionar lado do saque", @"Reconectar Placar" ,nil];
    [alert show];
    
}

-(void)sumirLetStroke{
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1.5);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        _telao_lbStroke.hidden = YES;
        _telao_lbLet.hidden = YES;
        _telao_lbMatch.hidden = YES;
        _telao_lbGameBall.hidden = YES;
        _btStroke.backgroundColor = NULL;
        _btLet.backgroundColor = NULL;
    });
}

- (void)popupLadoSaque {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tituloLadoSaque message:@"" delegate:self cancelButtonTitle:@"Esquerdo" otherButtonTitles:@"Direito", nil];
    [alert show];
    
    isPerguntarLadoSaque = NO;
}

- (void) alertaFimGameJogo:(BOOL)isFimJogo vencedor:(NSString *)nomeVencedor{
    NSString *titulo = @"Fim do Game";
    
    if(isFimJogo){
        titulo = @"Fim de jogo";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo message:nomeVencedor delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    if(isFimJogo){
        titulo = @"Fim de jogo";
    }
}


- (void) verificaPontuacao{
    fimJogo = NO;
    iniciarNovoGame = NO;
    
    int pontosJogador1 = _btPontosJogador1.value;
    int pontosJogador2 = _btPontosJogador2.value;
    
    if(pontosJogador1 >= 11 || pontosJogador2 >= 11){
        if([_dadosJogo.categoria containsString:@"Dupla"]){
            
            if(pontosJogador1 > pontosJogador2){
                gamesJogador1++;
                fimJogo = gamesJogador1 > (_dadosJogo.qtdGames/2);
                
                iniciarNovoGame = YES;
                [self alertaFimGameJogo:fimJogo vencedor:_lbJogador1.text];
                [self setaVencedor:_lbJogador1.text];
                
                NSString *pt = [[NSString alloc]initWithFormat:@"%i", pontosJogador1];
                [self addPontuacaoJogador1:pt game:gameAtual];
                
                
            } else if(pontosJogador2 > pontosJogador1){
                gamesJogador2++;
                fimJogo = gamesJogador2 > (_dadosJogo.qtdGames/2);
                _telao_lbTotalGamesJogador2.text = [[NSString alloc]initWithFormat:@"%i", gamesJogador2];
                
                iniciarNovoGame = YES;
                [self alertaFimGameJogo:fimJogo vencedor:_lbJogador2.text];
                [self setaVencedor:_lbJogador2.text];
                
                NSString *pt = [[NSString alloc]initWithFormat:@"%i ", pontosJogador2];
                [self addPontuacaoJogador2:pt game:gameAtual];
            }
        } else {
            if((pontosJogador1 - pontosJogador2) >= 2){
                gamesJogador1++;
                fimJogo = gamesJogador1 > (_dadosJogo.qtdGames/2);
                
                iniciarNovoGame = YES;
                [self alertaFimGameJogo:fimJogo vencedor:_lbJogador1.text];
                [self setaVencedor:_lbJogador1.text];
                
                NSString *pt = [[NSString alloc]initWithFormat:@"%i ", pontosJogador1];
                [self addPontuacaoJogador1:pt game:gameAtual];
                
            } else if((pontosJogador2 - pontosJogador1) >= 2){
                gamesJogador2++;
                fimJogo = gamesJogador2 > (_dadosJogo.qtdGames/2);
                _telao_lbTotalGamesJogador2.text = [[NSString alloc]initWithFormat:@"%i", gamesJogador2];
                
                iniciarNovoGame = YES;
                [self alertaFimGameJogo:fimJogo vencedor:_lbJogador2.text];
                [self setaVencedor:_lbJogador2.text];
                
                NSString *pt = [[NSString alloc]initWithFormat:@"%i ", pontosJogador2];
                [self addPontuacaoJogador2:pt game:gameAtual];
            }
        }

    }
    
    _telao_lbTotalGamesJogador1.text = [[NSString alloc]initWithFormat:@"%i", gamesJogador1];
    _telao_lbTotalGamesJogador2.text = [[NSString alloc]initWithFormat:@"%i", gamesJogador2];
    
    [self atualizaPlacarGeral:_btPontosJogador1.value e:_btPontosJogador2.value];
    
    if(fimJogo){
        [self finalizarTempoGame:gameAtual];
        [self fimDeJogo];

    } else if(iniciarNovoGame){
        [self finalizarTempoGame:gameAtual];
        [self novoGame];
        //Salvar
        [self salvarJogo:_dadosJogo];
    } else {
        [self delayBotaoPontos];
    }
}

-(void)fimDeJogo{
    _btPontosJogador1.hidden = YES;
    _btPontosJogador2.hidden = YES;
    _btLet.hidden = YES;
    _btStroke.hidden = YES;
    _btConfiguracoesJogo.hidden = YES;
}

- (void)novoGame{
    _btPontosJogador1.minimumValue = 0;
    _btPontosJogador2.minimumValue = 0;
    
    utlimaPontuacaoJogador1 = 0;
    utlimaPontuacaoJogador2 = 0;
    
    isPerguntarLadoSaque = YES;
    
    NSString *valor = [[NSString alloc]initWithFormat:@"%i", 0];
    _lbPontosJogador1.text = valor;
    _lbPontosJogador2.text = valor;
    _btPontosJogador1.value = 0;
    _btPontosJogador2.value = 0;
    
    gameAtual++;
    NSString *valorGame = [[NSString alloc]initWithFormat:@"%iº Game", gameAtual];
    _lbGame.text = valorGame;
    valor = nil;
    
    if([_dadosJogo.categoria containsString:@"Profissional"]){
        [self exibirTimmer:120];
    } else {
        [self exibirTimmer:90];
    }
    
    [self salvarJogo:_dadosJogo];
    
}

-(void)exibirTimmer:(int) tempo{
    [self.navigationItem setHidesBackButton:YES];
    segundosItervalo = tempo;
    _telao_lbTempo.text = [[NSString alloc] initWithFormat:@"%i", segundosItervalo];
    _lbTempo.textColor = [UIColor redColor];
    _lbTempo.text = [[NSString alloc] initWithFormat:@"%i", segundosItervalo];
    myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(contarTempo) userInfo:nil repeats: YES];
    
    _telao_lbTempo.hidden = NO;
    _lbTempo.hidden = NO;
    _btIniciarAgora.hidden = NO;
    
    _btPontosJogador1.hidden = YES;
    _btPontosJogador2.hidden = YES;
    _btConfiguracoesJogo.hidden = YES;
    _btLet.hidden = YES;
    _btStroke.hidden = YES;
    
    _lbGame.hidden = YES;
    _lbCategoria.hidden = YES;
    _lbPontosJogador1.hidden = YES;
    _lbPontosJogador2.hidden = YES;
    _lbJogador1.hidden = YES;
    _lbJogador2.hidden = YES;
    
}

-(void)contarTempo{
    _telao_lbTempo.text = [[NSString alloc] initWithFormat:@"%i", segundosItervalo];
    _lbTempo.text = [[NSString alloc] initWithFormat:@"%i", segundosItervalo];
    
    if(segundosItervalo == 150){
        _lbTempo.textColor = [UIColor blueColor];
    }
    
    if(segundosItervalo >= 0){
        segundosItervalo--;
    } else {
        [self finalizaContagemTempo];
    }
}

- (void)selecionaQuemSaca {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tituloQuemSaca message:@"" delegate:self cancelButtonTitle:_lbJogador1.text otherButtonTitles:_lbJogador2.text, nil];
    [alert show];
}

-(void)finalizaContagemTempo{
    if(!isMostrouTempo300){
        [self selecionaQuemSaca];
        isMostrouTempo300 = YES;
    }
    
    if(isPerguntarLadoSaque){
        [self popupLadoSaque];
    }
    
    [self iniciarTempoGame:gameAtual];
    
    _btIniciarAgora.hidden = YES;
    _telao_lbTempo.hidden = YES;
    _lbTempo.hidden = YES;
    
    _btPontosJogador1.hidden = NO;
    _btPontosJogador2.hidden = NO;
    _btConfiguracoesJogo.hidden = NO;
    _btLet.hidden = NO;
    _btStroke.hidden = NO;
    
    _lbGame.hidden = NO;
    _lbCategoria.hidden = NO;
    _lbPontosJogador1.hidden = NO;
    _lbPontosJogador2.hidden = NO;
    _lbJogador1.hidden = NO;
    _lbJogador2.hidden = NO;
    
    [self.navigationItem setHidesBackButton:NO];
    [myTimer invalidate];
}

-(void)iniciarTempoGame:(int)game{
    if(game == 1){
        _dadosJogo.dtInicioG1 = [NSDate date];
    } else if(game == 2){
        _dadosJogo.dtInicioG2 = [NSDate date];
    } else if(game == 3){
        _dadosJogo.dtInicioG3 = [NSDate date];
    } else if(game == 4){
        _dadosJogo.dtInicioG4 = [NSDate date];
    } else if(game == 5){
        _dadosJogo.dtInicioG5 = [NSDate date];
    }
}

-(void)finalizarTempoGame:(int)game{
    if(game == 1){
        _dadosJogo.dtFimG1 = [NSDate date];
    } else if(game == 2){
        _dadosJogo.dtFimG2 = [NSDate date];
    } else if(game == 3){
        _dadosJogo.dtFimG3 = [NSDate date];
    } else if(game == 4){
        _dadosJogo.dtFimG4 = [NSDate date];
    } else if(game == 5){
        _dadosJogo.dtFimG5 = [NSDate date];
    }
}

-(void)atualizaPlacarGeral:(int) pontos_1 e:(int) pontos_2 {
    if(gameAtual == 1){
        _telao_lbJogador1Game1.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _telao_lbJogador2Game1.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
        _lbJogador1Game1.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _lbJogador2Game1.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
    
    } else if(gameAtual == 2){
        _telao_lbJogador1Game2.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _telao_lbJogador2Game2.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
        _lbJogador1Game2.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _lbJogador2Game2.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
    
    } else if(gameAtual == 3){
        _telao_lbJogador1Game3.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _telao_lbJogador2Game3.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
        _lbJogador1Game3.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _lbJogador2Game3.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
    
    } else if(gameAtual == 4){
        _telao_lbJogador1Game4.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _telao_lbJogador2Game4.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
        _lbJogador1Game4.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _lbJogador2Game4.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
    
    } else if(gameAtual == 5){
        _telao_lbJogador1Game5.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _telao_lbJogador2Game5.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
        _lbJogador1Game5.text = [[NSString alloc] initWithFormat:@"%i", pontos_1];
        _lbJogador2Game5.text = [[NSString alloc] initWithFormat:@"%i", pontos_2];
    }
}

-(void)trocaLadoSaque{
    if ([_telao_bolaSaqueE isHidden] || [_bolaSaqueE isHidden]){
        [self selecionaLadoSaque:@"E"];
    } else {
        [self selecionaLadoSaque:@"D"];
    }
}

-(void)selecionaLadoSaque:(NSString *) ladoSaque{
    if ([ladoSaque isEqualToString:@"E"]){
        ladoUltimoSaque = @"E";
        _bolaSaqueE.hidden = NO;
        _bolaSaqueD.hidden = YES;
        _telao_bolaSaqueE.hidden = NO;
        _telao_bolaSaqueD.hidden = YES;
    } else {
        ladoUltimoSaque = @"D";
        _bolaSaqueE.hidden = YES;
        _bolaSaqueD.hidden = NO;
        _telao_bolaSaqueE.hidden = YES;
        _telao_bolaSaqueD.hidden = NO;
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([actionSheet.title isEqualToString:tituloLadoSaque]){
        if (buttonIndex == 0){
            [self selecionaLadoSaque:@"E"];
         } else {
            [self selecionaLadoSaque:@"D"];
        }
        
        if((int)_btPontosJogador1.value == 0 && (int)_btPontosJogador2.value == 0){
            if( [ultimoASacar isEqualToString:@"2"]){
                NSString *pt = [[NSString alloc]initWithFormat:@"%i %@", 0, ladoUltimoSaque];
                [self addPontuacaoJogador2:pt game:gameAtual];
            } else {
                NSString *pt = [[NSString alloc]initWithFormat:@"%i %@", 0, ladoUltimoSaque];
                [self addPontuacaoJogador1:pt game:gameAtual];
            }
        
        } else if((int)_btPontosJogador1.value > 1 && (int)_btPontosJogador2.value > 1){
            if( [ultimoASacar isEqualToString:@"2"]){
                [self delPontuacaoJogador2:gameAtual];
                NSString *pt = [[NSString alloc]initWithFormat:@"%i %@", (int)_btPontosJogador2.value, ladoUltimoSaque];
                [self addPontuacaoJogador2:pt game:gameAtual];
            } else {
                [self delPontuacaoJogador1:gameAtual];
                NSString *pt = [[NSString alloc]initWithFormat:@"%i %@", (int)_btPontosJogador1.value, ladoUltimoSaque];
                [self addPontuacaoJogador1:pt game:gameAtual];
            }
        }
        
        
    } else  if([actionSheet.title isEqualToString:tituloExcecoes]){
        if (buttonIndex == 1){
            [self selecionaQuemSaca];
        } else if (buttonIndex == 2){
            [self popupLadoSaque];
        } else if (buttonIndex == 3){
            [self reconectarPlacar];
        }
        
    } else {
        if (buttonIndex == 0){
            ultimoASacar = @"1";
            [self atualizaSacador: @"1"];
            NSLog(@"Jogador1");
        } else {
            NSLog(@"Jogador2");
            [self atualizaSacador: @"2"];
            ultimoASacar = @"2";
        }
        
        [self popupLadoSaque];
    }
}

-(void)reconectarPlacar{
    [self checkForExistingScreenAndInitializeIfPresent];
    [self atualizaTelao];
    [self atualizaPlacarGeral:_btPontosJogador1.value e:_btPontosJogador2.value];
    [self atualizaSacador: ultimoASacar];

}

- (void)checkForExistingScreenAndInitializeIfPresent
{
    if ([[UIScreen screens] count] > 1) {
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        CGRect screenBounds = secondScreen.bounds;
        self.secondWindow = [[UIWindow alloc] initWithFrame:screenBounds];
        self.secondWindow.screen = secondScreen;

        UIGraphicsBeginImageContext(secondScreen.bounds.size);
        UIImage *imagemFundo = [UIImage imageNamed:@"FundoGrande.png"];
        [imagemFundo drawInRect:CGRectMake(0, 0, secondScreen.bounds.size.width, secondScreen.bounds.size.height)];
        UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGRect subViewTelaoFrame = secondScreen.bounds;
        UIView *subViewTelao = [[UIView alloc] initWithFrame:subViewTelaoFrame];
        [subViewTelao setOpaque:NO];
        subViewTelao.backgroundColor=[UIColor colorWithPatternImage: destImage];
        [self.secondWindow addSubview:subViewTelao];
        self.secondWindow.hidden = NO;
        
        int tela_largura = secondScreen.bounds.size.width;
        int tela_altura = secondScreen.bounds.size.height;
        
        int foto_largura = 300;
        int foto_altura = 400;
        
        int tam_letra_nome = 30;
        int tam_bord = 9;
        int tam_letra_titulo = 38;
        
        // Label Game
        CGRect telao_rect_lbGame = secondScreen.bounds;
        telao_rect_lbGame.size.height = 50;
        _telao_lbGame = [[UILabel alloc]initWithFrame:telao_rect_lbGame];
        _telao_lbGame.text = _lbGame.text;
        _telao_lbGame.textColor = [UIColor blueColor];
        _telao_lbGame.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbGame.font = [UIFont fontWithName:@"Helvetica-Bold" size:tam_letra_titulo];
        _telao_lbGame.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbGame];
        
        /*Categoria
        CGRect telao_rect_lbCategoria = secondScreen.bounds;
        telao_rect_lbCategoria.size.height = 50;
        _telao_lbCategoria = [[UILabel alloc]initWithFrame:telao_rect_lbCategoria];
        _telao_lbCategoria.text = _lbCategoria.text;
        _telao_lbCategoria.textColor = [UIColor blueColor];
        _telao_lbCategoria.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbCategoria.font = [UIFont fontWithName:@"Helvetica-Bold" size:tam_letra_titulo];
        _telao_lbCategoria.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbCategoria];*/
        
        
        //Jogador 1
        CGRect telao_rect_lbJogador1 = CGRectMake(0, 52, (tela_largura / 2), 50);
        _telao_lbJogador1 = [[UILabel alloc]initWithFrame:telao_rect_lbJogador1];
        _telao_lbJogador1.text = _lbJogador1.text;
        _telao_lbJogador1.textColor = [UIColor blueColor];
        _telao_lbJogador1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbJogador1.font = [UIFont fontWithName:@"Helvetica-Bold" size:tam_letra_nome];
        _telao_lbJogador1.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador1];
        
        //Jogador 2
        CGRect telao_rect_lbJogador2 = CGRectMake(((tela_largura / 2) + 2), 52, ((tela_largura / 2)-2), 50);
        _telao_lbJogador2 = [[UILabel alloc]initWithFrame:telao_rect_lbJogador2];
        _telao_lbJogador2.text = _lbJogador2.text;
        _telao_lbJogador2.textColor = [UIColor blueColor];
        _telao_lbJogador2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbJogador2.font = [UIFont fontWithName:@"Helvetica-Bold" size:tam_letra_nome];
        _telao_lbJogador2.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador2];
        
        // Pontos Jogador 1
        CGRect telao_rect_lbPontosJogador1 = CGRectMake(foto_largura, 180, (tela_largura / 2)-foto_largura, 120);
        _telao_lbPontosJogador1 = [[UILabel alloc]initWithFrame:telao_rect_lbPontosJogador1];
        _telao_lbPontosJogador1.text = _lbPontosJogador2.text;
        _telao_lbPontosJogador1.textColor = [UIColor blueColor];
        _telao_lbPontosJogador1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbPontosJogador1.font = [UIFont fontWithName:@"Helvetica-Bold" size:100];
        _telao_lbPontosJogador1.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbPontosJogador1];
        
        // Pontos Jogador 2
        CGRect telao_rect_lbPontosJogador2 = CGRectMake((tela_largura / 2) + 2, 180, ((tela_largura / 2)-foto_largura)-2, 120);
        _telao_lbPontosJogador2 = [[UILabel alloc]initWithFrame:telao_rect_lbPontosJogador2];
        _telao_lbPontosJogador2.text = _lbPontosJogador2.text;
        _telao_lbPontosJogador2.textColor = [UIColor blueColor];
        _telao_lbPontosJogador2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbPontosJogador2.font = [UIFont fontWithName:@"Helvetica-Bold" size:100];
        _telao_lbPontosJogador2.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbPontosJogador2];
    
        //Campeonato
        CGRect telao_rect_lbCampeonato = CGRectMake(foto_largura + 2, 325, (tela_largura-(foto_largura*2))-4, 50);
        _telao_lbCampeonato = [[UILabel alloc]initWithFrame:telao_rect_lbCampeonato];
        _telao_lbCampeonato.text = _dadosJogo.campeonato;
        _telao_lbCampeonato.textColor = [UIColor blueColor];
        _telao_lbCampeonato.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbCampeonato.font = [UIFont fontWithName:@"Helvetica" size:30];
        _telao_lbCampeonato.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbCampeonato];
        
        //Categoria
        CGRect telao_rect_lbCategoria = CGRectMake(foto_largura + 2, 385, (tela_largura-(foto_largura*2))-4, 50);
        _telao_lbCategoria = [[UILabel alloc]initWithFrame:telao_rect_lbCategoria];
        _telao_lbCategoria.text = _lbCategoria.text;
        _telao_lbCategoria.textColor = [UIColor blueColor];
        _telao_lbCategoria.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbCategoria.font = [UIFont fontWithName:@"Helvetica" size:30];
        _telao_lbCategoria.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbCategoria];
        
        /* Logo Iate Jogador 1
        CGRect telao_rect_imgLogoIate1 = CGRectMake((foto_largura+39), 325, 50, 50);
        UIImageView *telao_imgLogoIate1 = [[UIImageView alloc]initWithFrame:telao_rect_imgLogoIate1];
        telao_imgLogoIate1.image = [UIImage imageNamed:@"LogoIate1.png"];
        [subViewTelao addSubview:telao_imgLogoIate1];*/
        
        /* Logo Iate Jogador 2
        CGRect telao_rect_imgLogoIate2 = CGRectMake((tela_largura-foto_largura)-75, 325, 50, 50);
        UIImageView *telao_imgLogoIate2 = [[UIImageView alloc]initWithFrame:telao_rect_imgLogoIate2];
        telao_imgLogoIate2.image = [UIImage imageNamed:@"LogoIate1.png"];
        [subViewTelao addSubview:telao_imgLogoIate2];*/
        
        // Borda Jogador 1
        CGRect telao_rect_bordaJogador1 = CGRectMake(0, 102, foto_largura+tam_bord, foto_altura + tam_bord);
        _telao_bordaJogador1 = [[UILabel alloc]initWithFrame:telao_rect_bordaJogador1];
        _telao_bordaJogador1.backgroundColor = [[UIColor greenColor] init];
        _telao_bordaJogador1.hidden = YES;
        [subViewTelao addSubview:_telao_bordaJogador1];
        
       // Imagem Jogador 1
        CGRect telao_rect_imgJogador1 = CGRectMake(0, 102, foto_largura, foto_altura);
        UIImageView *telao_imgJogador1 = [[UIImageView alloc]initWithFrame:telao_rect_imgJogador1];
        telao_imgJogador1.image = _dadosJogo.imgJogador1;
        [subViewTelao addSubview:telao_imgJogador1];
        
        // Borda Jogador 2
        CGRect telao_rect_bordaJogador2 = CGRectMake((tela_largura-foto_largura)-10, 102, foto_largura+tam_bord, foto_altura + tam_bord);
        _telao_bordaJogador2 = [[UILabel alloc]initWithFrame:telao_rect_bordaJogador2];
        _telao_bordaJogador2.backgroundColor = [[UIColor greenColor] init];
        _telao_bordaJogador2.hidden = YES;
        [subViewTelao addSubview:_telao_bordaJogador2];

        // Imagem Jogador 2
        CGRect telao_rect_imgJogador2 = CGRectMake((tela_largura-foto_largura), 102, foto_largura, foto_altura);
        UIImageView *telao_imgJogador2 = [[UIImageView alloc]initWithFrame:telao_rect_imgJogador2];
        telao_imgJogador2.image = _dadosJogo.imgJogador2;
        [subViewTelao addSubview:telao_imgJogador2];
        
        // Bola Saque Esquerda
        CGRect telao_rect_bolaSaqueE = CGRectMake((foto_largura -35)/2, (foto_altura + 170), 60, 60);
        _telao_bolaSaqueE = [[UIView alloc] initWithFrame:telao_rect_bolaSaqueE];
        [_telao_bolaSaqueE setOpaque:NO];
        _telao_bolaSaqueE.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"BolaSquash.png"]];
        _telao_bolaSaqueE.hidden = YES;
        [subViewTelao addSubview:_telao_bolaSaqueE];
        
        // Bola Saque Direita
        CGRect telao_rect_bolaSaqueD = CGRectMake((tela_largura-((foto_largura+35)/2)), (foto_altura + 170), 60, 60);
        _telao_bolaSaqueD = [[UIView alloc] initWithFrame:telao_rect_bolaSaqueD];
        [_telao_bolaSaqueD setOpaque:NO];
        _telao_bolaSaqueD.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"BolaSquash.png"]];
        _telao_bolaSaqueD.hidden = YES;
        [subViewTelao addSubview:_telao_bolaSaqueD];
        
        int placar_espacamento = 3;
        
        int x_nome_jogador = foto_largura - 100;
        
        if(_dadosJogo.qtdGames == 5){
            x_nome_jogador += 52;
        } else {
            x_nome_jogador += 104;
        }
        
        int largura_nome_jogador = 450;
        int largura_total = 50;
        int x_total = x_nome_jogador + largura_nome_jogador + placar_espacamento;
        
        int x_placar_jogador = x_nome_jogador + largura_nome_jogador + largura_total + placar_espacamento;
        
        int altura_colunas_placar = 51;
        int inicio_altura_placar = tela_altura - 210;
        
        int y_colunas = inicio_altura_placar;
        int y_colunas_tempo = inicio_altura_placar + altura_colunas_placar;
        int y_jogador1 = inicio_altura_placar + (altura_colunas_placar*2);
        int y_jogador2 = inicio_altura_placar + (altura_colunas_placar*3) ;
        
        int placar_largura = 48;
        
        float opacidade = 0.7;
        
        // Label Rodada
        CGRect telao_rect_lbRodada = CGRectMake(x_nome_jogador, y_colunas_tempo, largura_nome_jogador, placar_largura);
        UILabel *telao_lbRodada = [[UILabel alloc]initWithFrame:telao_rect_lbRodada];
        telao_lbRodada.textColor = [UIColor blackColor];
        telao_lbRodada.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbRodada.font = [UIFont fontWithName:@"Helvetica" size:25];
        telao_lbRodada.textAlignment = NSTextAlignmentCenter;
        telao_lbRodada.text = _dadosJogo.rodada;
        [subViewTelao addSubview:telao_lbRodada];
        
        // Label Nome Jogador 1 Placar
        CGRect telao_rect_lbNome1 = CGRectMake(x_nome_jogador, y_jogador1, largura_nome_jogador, placar_largura);
        UILabel *telao_lbNome1 = [[UILabel alloc]initWithFrame:telao_rect_lbNome1];
        telao_lbNome1.textColor = [UIColor blackColor];
        telao_lbNome1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbNome1.font = [UIFont fontWithName:@"American Typewriter" size:30];
        telao_lbNome1.textAlignment = NSTextAlignmentCenter;
        telao_lbNome1.text = _dadosJogo.jogador1;
        [subViewTelao addSubview:telao_lbNome1];
        
        // Label Nome Jogador 2 Placar
        CGRect telao_rect_lbNome2 = CGRectMake(x_nome_jogador, y_jogador2, largura_nome_jogador, placar_largura);
        UILabel *telao_lbNome2 = [[UILabel alloc]initWithFrame:telao_rect_lbNome2];
        telao_lbNome2.textColor = [UIColor blackColor];
        telao_lbNome2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbNome2.font = [UIFont fontWithName:@"American Typewriter" size:30];
        telao_lbNome2.textAlignment = NSTextAlignmentCenter;
        telao_lbNome2.text = _dadosJogo.jogador2;
        [subViewTelao addSubview:telao_lbNome2];
        
        // Label Total Games Jogador 1
        CGRect telao_rect_lbT1 = CGRectMake(x_total, y_jogador1, largura_total, placar_largura);
        _telao_lbTotalGamesJogador1 = [[UILabel alloc]initWithFrame:telao_rect_lbT1];
        _telao_lbTotalGamesJogador1.textColor = [UIColor blackColor];
        _telao_lbTotalGamesJogador1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbTotalGamesJogador1.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
        _telao_lbTotalGamesJogador1.textAlignment = NSTextAlignmentCenter;
        _telao_lbTotalGamesJogador1.text = @"0";
        [subViewTelao addSubview:_telao_lbTotalGamesJogador1];
        
        // Label Total Games Jogador 2
        CGRect telao_rect_lbT2 = CGRectMake(x_total, y_jogador2, largura_total, placar_largura);
        _telao_lbTotalGamesJogador2 = [[UILabel alloc]initWithFrame:telao_rect_lbT2];
        _telao_lbTotalGamesJogador2.textColor = [UIColor blackColor];
        _telao_lbTotalGamesJogador2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbTotalGamesJogador2.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
        _telao_lbTotalGamesJogador2.textAlignment = NSTextAlignmentCenter;
        _telao_lbTotalGamesJogador2.text = @"0";
        [subViewTelao addSubview:_telao_lbTotalGamesJogador2];
        
        // Label Resultado 1 Game 1
        CGRect telao_rect_lb0Game1 = CGRectMake(x_placar_jogador+placar_espacamento, y_colunas, placar_largura, placar_largura);
        UILabel *telao_lbColunas1 = [[UILabel alloc]initWithFrame:telao_rect_lb0Game1];
        telao_lbColunas1.textColor = [UIColor blackColor];
        telao_lbColunas1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbColunas1.font = [UIFont fontWithName:@"American Typewriter" size:30];
        telao_lbColunas1.textAlignment = NSTextAlignmentCenter;
        telao_lbColunas1.text = @"1º";
        [subViewTelao addSubview:telao_lbColunas1];
        
        // Label Resultado 1 Game 2
        CGRect telao_rect_lb0Game2 = CGRectMake(x_placar_jogador + placar_largura +(placar_espacamento*2), y_colunas, placar_largura, placar_largura);
        UILabel *telao_lbColunas2 = [[UILabel alloc]initWithFrame:telao_rect_lb0Game2];
        telao_lbColunas2.textColor = [UIColor blackColor];
        telao_lbColunas2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbColunas2.font = [UIFont fontWithName:@"American Typewriter" size:30];
        telao_lbColunas2.textAlignment = NSTextAlignmentCenter;
        telao_lbColunas2.text = @"2º";
        [subViewTelao addSubview:telao_lbColunas2];
        
        // Label Resultado 1 Game 3
        CGRect telao_rect_lb0Game3 = CGRectMake(x_placar_jogador + (placar_largura*2)+(placar_espacamento*3), y_colunas, placar_largura, placar_largura);
        UILabel *telao_lbColunas3 = [[UILabel alloc]initWithFrame:telao_rect_lb0Game3];
        telao_lbColunas3.textColor = [UIColor blackColor];
        telao_lbColunas3.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbColunas3.font = [UIFont fontWithName:@"American Typewriter" size:30];
        telao_lbColunas3.textAlignment = NSTextAlignmentCenter;
        telao_lbColunas3.text = @"3º";
        [subViewTelao addSubview:telao_lbColunas3];
        
        // Label Resultado 1 Game 4
        CGRect telao_rect_lb0Game4 = CGRectMake(x_placar_jogador + (placar_largura*3)+(placar_espacamento*4), y_colunas, placar_largura, placar_largura);
        UILabel *telao_lbColunas4 = [[UILabel alloc]initWithFrame:telao_rect_lb0Game4];
        telao_lbColunas4.textColor = [UIColor blackColor];
        telao_lbColunas4.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbColunas4.font = [UIFont fontWithName:@"American Typewriter" size:30];
        telao_lbColunas4.textAlignment = NSTextAlignmentCenter;
        telao_lbColunas4.text = @"4º";
        telao_lbColunas4.hidden = _dadosJogo.qtdGames<4;
        [subViewTelao addSubview:telao_lbColunas4];
        
        // Label Resultado 1 Game 5
        CGRect telao_rect_lb0Game5 = CGRectMake(x_placar_jogador + (placar_largura*4)+(placar_espacamento*5), y_colunas, placar_largura, placar_largura);
        UILabel *telao_lbColunas5 = [[UILabel alloc]initWithFrame:telao_rect_lb0Game5];
        telao_lbColunas5.textColor = [UIColor blackColor];
        telao_lbColunas5.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        telao_lbColunas5.font = [UIFont fontWithName:@"American Typewriter" size:30];
        telao_lbColunas5.textAlignment = NSTextAlignmentCenter;
        telao_lbColunas5.text = @"5º";
        telao_lbColunas5.hidden = _dadosJogo.qtdGames<5;
        [subViewTelao addSubview:telao_lbColunas5];
        
        
        
        //------- TEMPO ----------//
        
        
        // Label TEMPO Game 1
        CGRect telao_rect_lbTGame1 = CGRectMake(x_placar_jogador+placar_espacamento, y_colunas_tempo, placar_largura, placar_largura);
        _telao_lbTempo1 = [[UILabel alloc]initWithFrame:telao_rect_lbTGame1];
        _telao_lbTempo1.textColor = [UIColor blackColor];
        _telao_lbTempo1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbTempo1.font = [UIFont fontWithName:@"American Typewriter" size:15];
        _telao_lbTempo1.textAlignment = NSTextAlignmentCenter;
        _telao_lbTempo1.text = @"";
        [subViewTelao addSubview:_telao_lbTempo1];
        
        // Label TEMPO Game 2
        CGRect telao_rect_lbTGame2 = CGRectMake(x_placar_jogador + placar_largura +(placar_espacamento*2), y_colunas_tempo, placar_largura, placar_largura);
        _telao_lbTempo2 = [[UILabel alloc]initWithFrame:telao_rect_lbTGame2];
        _telao_lbTempo2.textColor = [UIColor blackColor];
        _telao_lbTempo2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbTempo2.font = [UIFont fontWithName:@"American Typewriter" size:15];
        _telao_lbTempo2.textAlignment = NSTextAlignmentCenter;
        _telao_lbTempo2.text = @"";
        [subViewTelao addSubview:_telao_lbTempo2];
        
        // Label TEMPO Game 3
        CGRect telao_rect_lbTGame3 = CGRectMake(x_placar_jogador + (placar_largura*2)+(placar_espacamento*3), y_colunas_tempo, placar_largura, placar_largura);
        _telao_lbTempo3 = [[UILabel alloc]initWithFrame:telao_rect_lbTGame3];
        _telao_lbTempo3.textColor = [UIColor blackColor];
        _telao_lbTempo3.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbTempo3.font = [UIFont fontWithName:@"American Typewriter" size:15];
        _telao_lbTempo3.textAlignment = NSTextAlignmentCenter;
        _telao_lbTempo3.text = @"";
        [subViewTelao addSubview:_telao_lbTempo3];
        
        // Label TEMPO Game 4
        CGRect telao_rect_lbTGame4 = CGRectMake(x_placar_jogador + (placar_largura*3)+(placar_espacamento*4), y_colunas_tempo, placar_largura, placar_largura);
        _telao_lbTempo4 = [[UILabel alloc]initWithFrame:telao_rect_lbTGame4];
        _telao_lbTempo4.textColor = [UIColor blackColor];
        _telao_lbTempo4.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbTempo4.font = [UIFont fontWithName:@"American Typewriter" size:15];
        _telao_lbTempo4.textAlignment = NSTextAlignmentCenter;
        _telao_lbTempo4.text = @"";
        _telao_lbTempo4.hidden = _dadosJogo.qtdGames<4;
        [subViewTelao addSubview:_telao_lbTempo4];
        
        // Label TEMPO Game 5
        CGRect telao_rect_lbTGame5 = CGRectMake(x_placar_jogador + (placar_largura*4)+(placar_espacamento*5), y_colunas_tempo, placar_largura, placar_largura);
        _telao_lbTempo5 = [[UILabel alloc]initWithFrame:telao_rect_lbTGame5];
        _telao_lbTempo5.textColor = [UIColor blackColor];
        _telao_lbTempo5.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbTempo5.font = [UIFont fontWithName:@"American Typewriter" size:15];
        _telao_lbTempo5.textAlignment = NSTextAlignmentCenter;
        _telao_lbTempo5.text = @"";
        _telao_lbTempo5.hidden = _dadosJogo.qtdGames<5;
        [subViewTelao addSubview:_telao_lbTempo5];
        
        
        // Label Resultado 1 Game 1
        CGRect telao_rect_lbGame1 = CGRectMake(x_placar_jogador + placar_espacamento, y_jogador1, placar_largura, placar_largura);
        _telao_lbJogador1Game1 = [[UILabel alloc]initWithFrame:telao_rect_lbGame1];
        _telao_lbJogador1Game1.textColor = [UIColor blackColor];
        _telao_lbJogador1Game1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador1Game1.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador1Game1.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador1Game1];
        
        // Label Resultado 1 Game 2
        CGRect telao_rect_lbGame2 = CGRectMake(x_placar_jogador + placar_largura +(placar_espacamento*2), y_jogador1, placar_largura, placar_largura);
        _telao_lbJogador1Game2 = [[UILabel alloc]initWithFrame:telao_rect_lbGame2];
        _telao_lbJogador1Game2.textColor = [UIColor blackColor];
        _telao_lbJogador1Game2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador1Game2.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador1Game2.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador1Game2];
        
        // Label Resultado 1 Game 3
        CGRect telao_rect_lbGame3 = CGRectMake(x_placar_jogador + (placar_largura*2)+(placar_espacamento*3), y_jogador1, placar_largura, placar_largura);
        _telao_lbJogador1Game3 = [[UILabel alloc]initWithFrame:telao_rect_lbGame3];
        _telao_lbJogador1Game3.textColor = [UIColor blackColor];
        _telao_lbJogador1Game3.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador1Game3.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador1Game3.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador1Game3];
        
        // Label Resultado 1 Game 4
        CGRect telao_rect_lbGame4 = CGRectMake(x_placar_jogador + (placar_largura*3)+(placar_espacamento*4), y_jogador1, placar_largura, placar_largura);
        _telao_lbJogador1Game4 = [[UILabel alloc]initWithFrame:telao_rect_lbGame4];
        _telao_lbJogador1Game4.textColor = [UIColor blackColor];
        _telao_lbJogador1Game4.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador1Game4.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador1Game4.textAlignment = NSTextAlignmentCenter;
        _telao_lbJogador1Game4.hidden = _dadosJogo.qtdGames<4;
        [subViewTelao addSubview:_telao_lbJogador1Game4];
        
        // Label Resultado 1 Game 5
        CGRect telao_rect_lbGame5 = CGRectMake(x_placar_jogador + (placar_largura*4)+(placar_espacamento*5), y_jogador1, placar_largura, placar_largura);
        _telao_lbJogador1Game5 = [[UILabel alloc]initWithFrame:telao_rect_lbGame5];
        _telao_lbJogador1Game5.textColor = [UIColor blackColor];
        _telao_lbJogador1Game5.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador1Game5.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador1Game5.textAlignment = NSTextAlignmentCenter;
        _telao_lbJogador1Game5.hidden = _dadosJogo.qtdGames<5;
        [subViewTelao addSubview:_telao_lbJogador1Game5];
        
        // Label Resultado 2 Game 1
        CGRect telao_rect_lb2Game1 = CGRectMake(x_placar_jogador + placar_espacamento, y_jogador2, placar_largura, placar_largura);
        _telao_lbJogador2Game1 = [[UILabel alloc]initWithFrame:telao_rect_lb2Game1];
        _telao_lbJogador2Game1.textColor = [UIColor blackColor];
        _telao_lbJogador2Game1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador2Game1.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador2Game1.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador2Game1];
        
        // Label Resultado 2 Game 2
        CGRect telao_rect_lb2Game2 = CGRectMake(x_placar_jogador + (placar_largura)+(placar_espacamento*2), y_jogador2, placar_largura, placar_largura);
        _telao_lbJogador2Game2 = [[UILabel alloc]initWithFrame:telao_rect_lb2Game2];
        _telao_lbJogador2Game2.textColor = [UIColor blackColor];
        _telao_lbJogador2Game2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador2Game2.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador2Game2.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador2Game2];
        
        // Label Resultado 2 Game 3
        CGRect telao_rect_lb2Game3 = CGRectMake(x_placar_jogador + (placar_largura*2)+(placar_espacamento*3), y_jogador2, placar_largura, placar_largura);
        _telao_lbJogador2Game3 = [[UILabel alloc]initWithFrame:telao_rect_lb2Game3];
        _telao_lbJogador2Game3.textColor = [UIColor blackColor];
        _telao_lbJogador2Game3.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador2Game3.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador2Game3.textAlignment = NSTextAlignmentCenter;
        [subViewTelao addSubview:_telao_lbJogador2Game3];
        
        // Label Resultado 2 Game 4
        CGRect telao_rect_lb2Game4 = CGRectMake(x_placar_jogador + (placar_largura*3)+(placar_espacamento*4), y_jogador2, placar_largura, placar_largura);
        _telao_lbJogador2Game4 = [[UILabel alloc]initWithFrame:telao_rect_lb2Game4];
        _telao_lbJogador2Game4.textColor = [UIColor blackColor];
        _telao_lbJogador2Game4.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador2Game4.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador2Game4.textAlignment = NSTextAlignmentCenter;
        _telao_lbJogador2Game4.hidden = _dadosJogo.qtdGames<4;
        [subViewTelao addSubview:_telao_lbJogador2Game4];
        
        // Label Resultado 2 Game 5
        CGRect telao_rect_lb2Game5 = CGRectMake(x_placar_jogador + (placar_largura*4)+(placar_espacamento*5), y_jogador2, placar_largura, placar_largura);
        _telao_lbJogador2Game5 = [[UILabel alloc]initWithFrame:telao_rect_lb2Game5];
        _telao_lbJogador2Game5.textColor = [UIColor blackColor];
        _telao_lbJogador2Game5.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:opacidade];
        _telao_lbJogador2Game5.font = [UIFont fontWithName:@"American Typewriter" size:30];
        _telao_lbJogador2Game5.textAlignment = NSTextAlignmentCenter;
        _telao_lbJogador2Game5.hidden = _dadosJogo.qtdGames<5;
        [subViewTelao addSubview:_telao_lbJogador2Game5];
        
        // Label Stroke
        CGRect telao_rect_lbStroke = secondScreen.bounds;
        _telao_lbStroke = [[UILabel alloc]initWithFrame:telao_rect_lbStroke];
        _telao_lbStroke.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbStroke.text = @"STROKE";
        _telao_lbStroke.textColor = [UIColor redColor];
        _telao_lbStroke.font = [UIFont fontWithName:@"Helvetica-Bold" size:300];
        _telao_lbStroke.textAlignment = NSTextAlignmentCenter;
        _telao_lbStroke.hidden = YES;
        [subViewTelao addSubview:_telao_lbStroke];
        
        // Label LET
        CGRect telao_rect_lbLet = secondScreen.bounds;
        _telao_lbLet = [[UILabel alloc]initWithFrame:telao_rect_lbLet];
        _telao_lbLet.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbLet.text = @"LET";
        _telao_lbLet.textColor = [UIColor redColor];
        _telao_lbLet.font = [UIFont fontWithName:@"Helvetica-Bold" size:300];
        _telao_lbLet.textAlignment = NSTextAlignmentCenter;
        _telao_lbLet.hidden = YES;
        [subViewTelao addSubview:_telao_lbLet];
        
        // Label MATCH
        CGRect telao_rect_lbMatch = secondScreen.bounds;
        _telao_lbMatch = [[UILabel alloc]initWithFrame:telao_rect_lbMatch];
        _telao_lbMatch.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbMatch.text = @"MATCH BALL";
        _telao_lbMatch.textColor = [UIColor redColor];
        _telao_lbMatch.font = [UIFont fontWithName:@"Helvetica-Bold" size:150];
        _telao_lbMatch.textAlignment = NSTextAlignmentCenter;
        _telao_lbMatch.hidden = YES;
        [subViewTelao addSubview:_telao_lbMatch];
        
        // Label GAME BALL
        CGRect telao_rect_lbGameBall = secondScreen.bounds;
        _telao_lbGameBall = [[UILabel alloc]initWithFrame:telao_rect_lbGameBall];
        _telao_lbGameBall.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbGameBall.text = @"GAME BALL";
        _telao_lbGameBall.textColor = [UIColor redColor];
        _telao_lbGameBall.font = [UIFont fontWithName:@"Helvetica-Bold" size:150];
        _telao_lbGameBall.textAlignment = NSTextAlignmentCenter;
        _telao_lbGameBall.hidden = YES;
        [subViewTelao addSubview:_telao_lbGameBall];
        
        // Label Tempo
        CGRect telao_rect_lbTempo = secondScreen.bounds;
        _telao_lbTempo = [[UILabel alloc]initWithFrame:telao_rect_lbTempo];
        _telao_lbTempo.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
        _telao_lbTempo.text = @"00";
        _telao_lbTempo.textColor = [UIColor redColor];
        _telao_lbTempo.font = [UIFont fontWithName:@"Helvetica-Bold" size:300];
        _telao_lbTempo.textAlignment = NSTextAlignmentCenter;
        _telao_lbTempo.hidden = YES;
        [subViewTelao addSubview:_telao_lbTempo];
                
        [self recolocaValoresPontuacao];
        [self atualizaDuracaoGames];
    }
}

-(void)recolocaValoresPontuacao{
    _telao_lbJogador1Game1.text = [NSString stringWithFormat:@"%@", _lbJogador1Game1.text];
    _telao_lbJogador1Game2.text = [NSString stringWithFormat:@"%@", _lbJogador1Game2.text];
    _telao_lbJogador1Game3.text = [NSString stringWithFormat:@"%@", _lbJogador1Game3.text];
    _telao_lbJogador1Game4.text = [NSString stringWithFormat:@"%@", _lbJogador1Game4.text];
    _telao_lbJogador1Game5.text = [NSString stringWithFormat:@"%@", _lbJogador1Game5.text];
   
    _telao_lbJogador2Game1.text = [NSString stringWithFormat:@"%@", _lbJogador2Game1.text];
    _telao_lbJogador2Game2.text = [NSString stringWithFormat:@"%@", _lbJogador2Game2.text];
    _telao_lbJogador2Game3.text = [NSString stringWithFormat:@"%@", _lbJogador2Game3.text];
    _telao_lbJogador2Game4.text = [NSString stringWithFormat:@"%@", _lbJogador2Game4.text];
    _telao_lbJogador2Game5.text = [NSString stringWithFormat:@"%@", _lbJogador2Game5.text];

}

-(void)atualizaDuracaoGames{
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = destinationTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"mm:ss"];
    
    NSString *dateString = @"01-01-2014 00:00:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *dateSinceDuration = [[NSDate alloc] init];
    dateSinceDuration = [dateFormatter dateFromString:dateString];
    
    if(_dadosJogo.dtFimG5 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG5 timeIntervalSinceDate: _dadosJogo.dtInicioG5];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        _telao_lbTempo5.text = [formatter stringFromDate:endDate];
        
    }
    
    if(_dadosJogo.dtFimG4 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG4 timeIntervalSinceDate: _dadosJogo.dtInicioG4];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        _telao_lbTempo4.text = [formatter stringFromDate:endDate];
        
    }
    
    if(_dadosJogo.dtFimG3 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG3 timeIntervalSinceDate: _dadosJogo.dtInicioG3];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        _telao_lbTempo3.text = [formatter stringFromDate:endDate];
        
    }
    
    if(_dadosJogo.dtFimG2 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG2 timeIntervalSinceDate: _dadosJogo.dtInicioG2];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        _telao_lbTempo2.text = [formatter stringFromDate:endDate];
        
    }
    
    if(_dadosJogo.dtFimG1 != nil){
        CGFloat intervalo = [_dadosJogo.dtFimG1 timeIntervalSinceDate: _dadosJogo.dtInicioG1];
        NSDate *endDate = [NSDate dateWithTimeInterval:intervalo sinceDate:dateSinceDuration];
        _telao_lbTempo1.text = [formatter stringFromDate:endDate];
        
    }
}

- (void)atualizaTelao {
    _telao_lbPontosJogador1.text = _lbPontosJogador1.text;
    _telao_lbPontosJogador2.text = _lbPontosJogador2.text;
    _telao_lbGame.text = _lbGame.text;
    [self atualizaDuracaoGames];
}

-(void)atualizaSacador:(NSString *) sacador{
    if([sacador isEqualToString:@"1"]){
        ultimoASacar = @"1";
        _lbJogador1.textColor = [UIColor blueColor];
        _lbJogador2.textColor = [UIColor blackColor];
        _telao_bordaJogador1.hidden = NO;
        _telao_bordaJogador2.hidden = YES;
    } else {
        ultimoASacar = @"2";
        _lbJogador1.textColor = [UIColor blackColor];
        _lbJogador2.textColor = [UIColor blueColor];
        _telao_bordaJogador1.hidden = YES;
        _telao_bordaJogador2.hidden = NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if(_dadosJogo == nil){
       _dadosJogo = [[DadosJogo alloc]init];
    }
    
    if([segue.identifier isEqualToString:@"telaSumula"]){
        ViewControllerSumula *proximaTela = segue.destinationViewController;
        proximaTela.dadosJogo =_dadosJogo;
        proximaTela.dadosJogo.totalJ1G1 = _lbJogador1Game1.text;
        proximaTela.dadosJogo.totalJ1G2 = _lbJogador1Game2.text;
        proximaTela.dadosJogo.totalJ1G3 = _lbJogador1Game3.text;
        proximaTela.dadosJogo.totalJ1G4 = _lbJogador1Game4.text;
        proximaTela.dadosJogo.totalJ1G5 = _lbJogador1Game5.text;
        proximaTela.dadosJogo.total21G1 = _lbJogador2Game1.text;
        proximaTela.dadosJogo.total21G2 = _lbJogador2Game2.text;
        proximaTela.dadosJogo.total21G3 = _lbJogador2Game3.text;
        proximaTela.dadosJogo.total21G4 = _lbJogador2Game4.text;
        proximaTela.dadosJogo.total21G5 = _lbJogador2Game5.text;
        proximaTela.dadosJogo.totalGames1 = [[NSString alloc] initWithFormat:@"%i", gamesJogador1];
        proximaTela.dadosJogo.totalGames2 = [[NSString alloc] initWithFormat:@"%i", gamesJogador2];
    }
 }

-(void)atualizaDadosJogoNaVariavelGlobal{
    
}

-(void)setaVencedor:(NSString *)nomeVencedor{
    if (gameAtual == 1) {
        _dadosJogo.vencedorG1 = nomeVencedor;
    } else if (gameAtual == 2) {
        _dadosJogo.vencedorG2 = nomeVencedor;
    } else if (gameAtual == 3) {
        _dadosJogo.vencedorG3 = nomeVencedor;
    } else if (gameAtual == 4) {
        _dadosJogo.vencedorG4 = nomeVencedor;
    } else if (gameAtual == 5) {
        _dadosJogo.vencedorG5 = nomeVencedor;
    }
}



@end
