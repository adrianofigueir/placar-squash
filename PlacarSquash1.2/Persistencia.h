//
//  Persistencia.h
//  Placar Squash
//
//  Created by Yan Grunes de Alencar on 04/09/16.
//  Copyright © 2016 deBoa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DadosJogo.h"
#import "DadosSumula.h"


@interface Persistencia : NSObject

-(void)abrir;
-(void)fechar;

-(void)deletar:(DadosJogo*)jogo;
-(NSMutableArray*)consultar:(DadosJogo*) dadosJ;
-(void)salvar:(DadosJogo*)dadosJogo;

-(DadosSumula*)consultarDadosSumula;
-(void)salvarDadosSumula:(DadosSumula*)dadosSumula;
-(void)deletarDadosSumula:(DadosSumula*)dadosSumula;

-(void)salvarFotos:(DadosJogo*) dadosJogo;
-(DadosJogo*)consultarFotos:(DadosJogo*)dadosJ;
-(void)deletarFotos:(DadosJogo*)jogo;

@end
