//
//  DadosJogo.m
//  PlacarSquash1.2
//
//  Created by Adriano on 03/08/14.
//  Copyright (c) 2014 deBoa. All rights reserved.
//

#import "DadosJogo.h"

@implementation DadosJogo
- (NSString *)description
{
    return [NSString stringWithFormat:@"Dados do jogo:id=%d  nome=%@", self.idObjeto,self.jogador1];
}

@end
