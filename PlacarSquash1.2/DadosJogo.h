//
//  DadosJogo.h
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DadosJogo : NSObject

@property (strong, nonatomic) NSString *numeroCampeonato;
@property (strong, nonatomic) NSString *campeonato;
@property (strong, nonatomic) NSString *rodada;
@property (strong, nonatomic) NSString *jogador1;
@property (strong, nonatomic) NSString *jogador2;
@property (strong, nonatomic) NSString *categoria;
@property (strong, nonatomic) NSString *genero;

@property (strong, nonatomic) NSString *totalJ1G1;
@property (strong, nonatomic) NSString *totalJ1G2;
@property (strong, nonatomic) NSString *totalJ1G3;
@property (strong, nonatomic) NSString *totalJ1G4;
@property (strong, nonatomic) NSString *totalJ1G5;

@property (strong, nonatomic) NSString *total21G1;
@property (strong, nonatomic) NSString *total21G2;
@property (strong, nonatomic) NSString *total21G3;
@property (strong, nonatomic) NSString *total21G4;
@property (strong, nonatomic) NSString *total21G5;

@property (strong, nonatomic) NSString *totalGames2;
@property (strong, nonatomic) NSString *totalGames1;

@property (strong, nonatomic) NSString *juiz;
@property (strong, nonatomic) NSString *quadra;
@property (strong, nonatomic) NSString *marcador;

@property (strong, nonatomic) UIImage *imgJogador1;
@property (strong, nonatomic) UIImage *imgJogador2;

@property (nonatomic) int qtdGames;
@property (nonatomic) int idObjeto;
@property (nonatomic) int gameAtual;
@property (nonatomic) int gamesJogador1;
@property (nonatomic) int gamesJogador2;

@property (strong, nonatomic) NSMutableArray *pontosGame1Jogador1;
@property (strong, nonatomic) NSMutableArray *pontosGame1Jogador2;
@property (strong, nonatomic) NSMutableArray *pontosGame2Jogador1;
@property (strong, nonatomic) NSMutableArray *pontosGame2Jogador2;
@property (strong, nonatomic) NSMutableArray *pontosGame3Jogador1;
@property (strong, nonatomic) NSMutableArray *pontosGame3Jogador2;
@property (strong, nonatomic) NSMutableArray *pontosGame4Jogador1;
@property (strong, nonatomic) NSMutableArray *pontosGame4Jogador2;
@property (strong, nonatomic) NSMutableArray *pontosGame5Jogador1;
@property (strong, nonatomic) NSMutableArray *pontosGame5Jogador2;

@property (strong, nonatomic) NSString *vencedorG1;
@property (strong, nonatomic) NSString *vencedorG2;
@property (strong, nonatomic) NSString *vencedorG3;
@property (strong, nonatomic) NSString *vencedorG4;
@property (strong, nonatomic) NSString *vencedorG5;

@property (strong, nonatomic) NSDate *dtInicioG1;
@property (strong, nonatomic) NSDate *dtInicioG2;
@property (strong, nonatomic) NSDate *dtInicioG3;
@property (strong, nonatomic) NSDate *dtInicioG4;
@property (strong, nonatomic) NSDate *dtInicioG5;

@property (strong, nonatomic) NSDate *dtFimG1;
@property (strong, nonatomic) NSDate *dtFimG2;
@property (strong, nonatomic) NSDate *dtFimG3;
@property (strong, nonatomic) NSDate *dtFimG4;
@property (strong, nonatomic) NSDate *dtFimG5;

@property (strong, nonatomic) NSString *ultimoASacar;


@end
