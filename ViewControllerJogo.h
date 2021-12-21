//
//  ViewControllerJogo.h
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ViewController.h"
#import "ViewControllerSumula.h"
#import "DadosJogo.h"

@interface ViewControllerJogo : ViewController <UIAlertViewDelegate>{
    NSString *ultimoASacar;
    
    int ultimoAPontuar;
    
    int gameAtual;
    int segundosItervalo;
    int utlimaPontuacaoJogador1;
    int utlimaPontuacaoJogador2;
    
    int gamesJogador1;
    int gamesJogador2;
    
    BOOL isMostrouTempo300;
    BOOL isPerguntarLadoSaque;
    
    NSString *ladoUltimoSaque;
    
    NSString *pdfFilePath;
    CGSize *pageSize;
    
    NSString *tituloFimJogo;
    NSString *tituloFimGame;
    NSString *tituloExcecoes;
    NSString *tituloQuemSaca;
    NSString *tituloLadoSaque;
    
    BOOL fimJogo;
    BOOL iniciarNovoGame;
}
@property (strong, nonatomic) IBOutlet UILabel *lbCategoria;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador1;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador2;
@property (strong, nonatomic) IBOutlet UILabel *lbPontosJogador1;
@property (strong, nonatomic) IBOutlet UILabel *lbPontosJogador2;
@property (strong, nonatomic) IBOutlet UILabel *lbGame;

@property (strong, nonatomic) IBOutlet UILabel *telao_lbTotalGamesJogador1;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbTotalGamesJogador2;

@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador1Game1;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador1Game2;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador1Game3;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador1Game4;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador1Game5;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador1Game6;

@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador2Game1;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador2Game2;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador2Game3;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador2Game4;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador2Game5;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador2Game6;

@property (strong, nonatomic) IBOutlet UILabel *telao_lbCampeonato;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbCategoria;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador1;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbJogador2;
@property (strong, nonatomic) IBOutlet UILabel *telao_bordaJogador1;
@property (strong, nonatomic) IBOutlet UILabel *telao_bordaJogador2;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbPontosJogador1;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbPontosJogador2;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbGame;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbStroke;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbLet;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbMatch;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbGameBall;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbTempo;
@property (strong, nonatomic) IBOutlet UILabel *lbTempo;

@property (strong, nonatomic) IBOutlet UILabel *telao_lbTempo1;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbTempo2;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbTempo3;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbTempo4;
@property (strong, nonatomic) IBOutlet UILabel *telao_lbTempo5;

@property (strong, nonatomic) IBOutlet UIView *telao_bolaSaqueE;
@property (strong, nonatomic) IBOutlet UIView *telao_bolaSaqueD;

@property (strong, nonatomic) IBOutlet UIImageView *bolaSaqueE;
@property (strong, nonatomic) IBOutlet UIImageView *bolaSaqueD;

@property (strong, nonatomic) IBOutlet UIStepper *btPontosJogador1;
@property (strong, nonatomic) IBOutlet UIStepper *btPontosJogador2;

@property (strong, nonatomic) IBOutlet UIButton *btLet;
@property (strong, nonatomic) IBOutlet UIButton *btStroke;

@property (strong, nonatomic) DadosJogo *dadosJogo;
@property (strong, nonatomic) IBOutlet UILabel *lbTimer;
@property (strong, nonatomic) IBOutlet UIButton *btIniciarAgora;

@property (strong, nonatomic) IBOutlet UILabel *lbJogador1Game1;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador1Game2;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador1Game3;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador1Game4;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador1Game5;

@property (strong, nonatomic) IBOutlet UILabel *lbJogador2Game1;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador2Game2;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador2Game3;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador2Game4;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador2Game5;

@property (strong, nonatomic) IBOutlet UILabel *lbJogador1Placar;
@property (strong, nonatomic) IBOutlet UILabel *lbJogador2Placar;
@property (strong, nonatomic) IBOutlet UILabel *btExcecao;
@property (strong, nonatomic) IBOutlet UIButton *btConfiguracoesJogo;

- (IBAction)actBtPontosJogador1:(id)sender;
- (IBAction)actBtPontosJogador2:(id)sender;
- (IBAction)acionaStroke:(id)sender;
- (IBAction)acionaLet:(id)sender;

- (IBAction)iniciarAgora:(id)sender;
- (IBAction)actBtExcecao:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btLimparJogo;


@end
