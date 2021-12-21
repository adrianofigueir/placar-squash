//
//  Persistencia.m
//  Placar Squash
//
//  Created by Yan Grunes de Alencar on 04/09/16.
//  Copyright © 2016 deBoa. All rights reserved.
//

#import "Persistencia.h"

sqlite3 *bancoDeDados;

NSString *nomeBanco = @"PlacarSquash_1.0.0";

NSString *sqlCreate = @"create table if not exists DadosJogo(idObjeto integer primary key,numeroCampeonato text,campeonato text,rodada text,jogador1 text,jogador2 text,categoria text,genero text,qtdGames integer, totalJ1G1 text,totalJ1G2 text,totalJ1G3 text,totalJ1G4 text,totalJ1G5 text,total21G1 text,total21G2 text,total21G3 text,total21G4 text,total21G5 text,totalGames2 text,totalGames1 text,vencedorG1 text,vencedorG2 text,vencedorG3 text,vencedorG4 text,vencedorG5 text, dtInicioG1 text,dtInicioG2 text,dtInicioG3 text,dtInicioG4 text,dtInicioG5 text,dtFimG1 text,dtFimG2 text,dtFimG3 text,dtFimG4 text,dtFimG5 text,ultimoASacar text, gameAtual integer, pontosGame1Jogador1 BLOB, pontosGame1Jogador2 BLOB, pontosGame2Jogador1 BLOB, pontosGame2Jogador2 BLOB,pontosGame3Jogador1 BLOB, pontosGame3Jogador2 BLOB, pontosGame4Jogador1 BLOB, pontosGame4Jogador2 BLOB, pontosGame5Jogador1 BLOB, pontosGame5Jogador2 BLOB)";

NSString *sqlInsert = @"insert or replace into DadosJogo(idObjeto, numeroCampeonato, campeonato, rodada, jogador1, jogador2, categoria, genero, qtdGames, totalJ1G1, totalJ1G2, totalJ1G3, totalJ1G4, totalJ1G5, total21G1, total21G2, total21G3, total21G4, total21G5, totalGames2, totalGames1, vencedorG1, vencedorG2, vencedorG3, vencedorG4, vencedorG5, dtInicioG1, dtInicioG2, dtInicioG3, dtInicioG4, dtInicioG5, dtFimG1, dtFimG2, dtFimG3, dtFimG4, dtFimG5, ultimoASacar, gameAtual, pontosGame1Jogador1, pontosGame1Jogador2, pontosGame2Jogador1,pontosGame2Jogador2, pontosGame3Jogador1, pontosGame3Jogador2, pontosGame4Jogador1, pontosGame4Jogador2, pontosGame5Jogador1, pontosGame5Jogador2) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";

NSString *sqlSelect = @"select idObjeto, numeroCampeonato, campeonato, rodada, jogador1, jogador2, categoria, genero, qtdGames, totalJ1G1, totalJ1G2, totalJ1G3, totalJ1G4, totalJ1G5, total21G1, total21G2, total21G3, total21G4, total21G5, totalGames2, totalGames1, vencedorG1, vencedorG2, vencedorG3, vencedorG4, vencedorG5, dtInicioG1, dtInicioG2, dtInicioG3, dtInicioG4, dtInicioG5, dtFimG1, dtFimG2, dtFimG3, dtFimG4, dtFimG5, ultimoASacar, gameAtual, pontosGame1Jogador1, pontosGame1Jogador2, pontosGame2Jogador1,pontosGame2Jogador2, pontosGame3Jogador1, pontosGame3Jogador2, pontosGame4Jogador1, pontosGame4Jogador2, pontosGame5Jogador1, pontosGame5Jogador2 from DadosJogo";

NSString *sqlDelete = @"delete from DadosJogo";


// Fotos do jogo salvas separatamente
NSString *sqlCreateFotos = @"create table if not exists Fotos(idObjeto integer primary key, imgJogador1 BLOB, imgJogador2 BLOB)";

NSString *sqlInsertFotos = @"insert or replace into Fotos(idObjeto, imgJogador1, imgJogador2) values (?,?,?)";

NSString *sqlSelectFotos = @"select idObjeto, imgJogador1, imgJogador2 from Fotos";

NSString *sqlDeleteFotos = @"delete from Fotos";


// Dados da tela de Súmula ficam separados
NSString *sqlCreateDadosSumula = @"create table if not exists DadosSumula(idObjeto integer primary key, quadra text,marcador text,juiz text)";

NSString *sqlInsertDadosSumula = @"insert or replace into DadosSumula(idObjeto, quadra, marcador, juiz) values (?,?,?,?)";

NSString *sqlSelectDadosSumula = @"select idObjeto, quadra, marcador, juiz from DadosSumula";

NSString *sqlDeleteDadosSumula = @"delete from DadosSumula where idObjeto=?";

@implementation Persistencia

-(NSString*)caminhoDoArquivo{
    NSString* db = [NSString stringWithFormat:@"%@.sqlite3",nomeBanco];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * caminhoArquivo = [documentsDirectory stringByAppendingPathComponent:db];
    return caminhoArquivo;
}

-(void)fechar{
    sqlite3_close(bancoDeDados);
}

-(void)abrir{
    NSString *caminhoArquivo = [self caminhoDoArquivo];
    int resultado = sqlite3_open([caminhoArquivo UTF8String],&bancoDeDados);
    if (resultado == SQLITE_OK) {
        char * erroMsg;
        resultado = sqlite3_exec(bancoDeDados,[sqlCreate UTF8String],NULL,NULL,&erroMsg);
        resultado = sqlite3_exec(bancoDeDados,[sqlCreateDadosSumula UTF8String],NULL,NULL,&erroMsg);
        resultado = sqlite3_exec(bancoDeDados,[sqlCreateFotos UTF8String],NULL,NULL,&erroMsg);
    }else{
        NSLog(@"ERRO NO BANCO!!!!");
    }
}

-(NSMutableArray*)consultar:(DadosJogo*) dadosJ{
    
    NSMutableArray *dados = [[NSMutableArray alloc]init];
    sqlite3_stmt *stmt;
    int resultado = sqlite3_prepare_v2(bancoDeDados, [sqlSelect UTF8String], -1, &stmt, nil);
    if (resultado == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {

            //conversao
            const void *ptr = sqlite3_column_blob(stmt,1);
            int size = sqlite3_column_bytes(stmt, 1);
            NSData *teste = [[NSData alloc] initWithBytes:ptr length:size];
            
            if (teste != nil) {
                
                int indexStmt = 0;
                dadosJ.idObjeto = sqlite3_column_int(stmt,indexStmt);
                
                indexStmt++;
                char *s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.numeroCampeonato = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.campeonato = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.rodada = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.jogador1 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.jogador2 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.categoria = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.genero = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                dadosJ.qtdGames = sqlite3_column_int(stmt,indexStmt);
                
                //Tela2
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.totalJ1G1 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.totalJ1G2 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.totalJ1G3 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.totalJ1G4 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.totalJ1G5 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.total21G1 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.total21G2 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.total21G3 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.total21G4 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.total21G5 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.totalGames2 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.totalGames1 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.vencedorG1 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.vencedorG2 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.vencedorG3 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.vencedorG4 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.vencedorG5 = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                //
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
                formatter.timeZone = destinationTimeZone;
                [formatter setDateStyle:NSDateFormatterLongStyle];
                [formatter setDateFormat:@"HH:mm:ss"];
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtInicioG1 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtInicioG2 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtInicioG3 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtInicioG4 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtInicioG5 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtFimG1 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtFimG2 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtFimG3 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtFimG4 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.dtFimG5 = s != nil ? [formatter dateFromString:[NSString stringWithUTF8String:s]] : nil;
                //DadosUteis
                
                indexStmt++;
                s =(char*)sqlite3_column_text(stmt, indexStmt);
                dadosJ.ultimoASacar = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                dadosJ.gameAtual = sqlite3_column_int(stmt,indexStmt);
                if(dadosJ.gameAtual < 1){
                    dadosJ.gameAtual = 1;
                }
                
                //conversao
                indexStmt++;
                const void *ptrArr1 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr1 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData1 = [[NSData alloc] initWithBytes:ptrArr1 length:sizeArr1];
                dadosJ.pontosGame1Jogador1 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData1]];
               
                //conversao
                indexStmt++;
                const void *ptrArr2 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr2 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData2 = [[NSData alloc] initWithBytes:ptrArr2 length:sizeArr2];
                dadosJ.pontosGame1Jogador2 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData2]];
                
                //conversao
                indexStmt++;
                const void *ptrArr3 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr3 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData3 = [[NSData alloc] initWithBytes:ptrArr3 length:sizeArr3];
                dadosJ.pontosGame2Jogador1 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData3]];
                
                //conversao
                indexStmt++;
                const void *ptrArr4 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr4 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData4 = [[NSData alloc] initWithBytes:ptrArr4 length:sizeArr4];
                dadosJ.pontosGame2Jogador2 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData4]];
                
                //conversao
                indexStmt++;
                const void *ptrArr5 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr5 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData5 = [[NSData alloc] initWithBytes:ptrArr5 length:sizeArr5];
                dadosJ.pontosGame3Jogador1 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData5]];
                
                //conversao
                indexStmt++;
                const void *ptrArr6 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr6 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData6 = [[NSData alloc] initWithBytes:ptrArr6 length:sizeArr6];
                dadosJ.pontosGame3Jogador2 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData6]];
                
                //conversao
                indexStmt++;
                const void *ptrArr7 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr7 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData7 = [[NSData alloc] initWithBytes:ptrArr7 length:sizeArr7];
                dadosJ.pontosGame4Jogador1 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData7]];
                
                //conversao
                indexStmt++;
                const void *ptrArr8 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr8 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData8 = [[NSData alloc] initWithBytes:ptrArr8 length:sizeArr8];
                dadosJ.pontosGame4Jogador2 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData8]];
                
                //conversao
                indexStmt++;
                const void *ptrArr9 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr9 = sqlite3_column_bytes(stmt,indexStmt);
                NSData *arrData9 = [[NSData alloc] initWithBytes:ptrArr9 length:sizeArr9];
                dadosJ.pontosGame5Jogador1 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData9]];
                
                //conversao
                indexStmt++;
                const void *ptrArr10 = sqlite3_column_blob(stmt,indexStmt);
                int sizeArr10 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *arrData10 = [[NSData alloc] initWithBytes:ptrArr10 length:sizeArr10];
                dadosJ.pontosGame5Jogador2 =[[NSMutableArray alloc]initWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:arrData10]];
                
                [dados addObject:dadosJ];
            }
        }
        sqlite3_finalize(stmt);
        
    } else {
        NSLog(@"Erro no Statement Consultar");
    }
    
    return dados;
}

-(void)salvar:(DadosJogo*) dadosJogo{
    sqlite3_stmt *stmt;
    int resultado = sqlite3_prepare_v2(bancoDeDados,[sqlInsert UTF8String],-1,&stmt,nil);
    if(resultado == SQLITE_OK){
        
        int indexStmt = 1;
        sqlite3_bind_int(stmt,indexStmt, dadosJogo.idObjeto);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.numeroCampeonato UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.campeonato UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.rodada UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.jogador1 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.jogador2 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.categoria UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.genero UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_int(stmt, indexStmt, dadosJogo.qtdGames);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.totalJ1G1 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.totalJ1G2 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.totalJ1G3 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.totalJ1G4 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.totalJ1G5 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.total21G1 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.total21G2 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.total21G3 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.total21G4 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.total21G5 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.totalGames2 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.totalGames1 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.vencedorG1 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.vencedorG2 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.vencedorG3 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.vencedorG4 UTF8String],-1,nil);
        
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.vencedorG5 UTF8String],-1,nil);
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
        formatter.timeZone = destinationTimeZone;
        [formatter setDateStyle:NSDateFormatterLongStyle];
        [formatter setDateFormat:@"HH:mm:ss"];
        //
        indexStmt ++;
        NSString *dti1 = [formatter stringFromDate:dadosJogo.dtInicioG1];
        sqlite3_bind_text(stmt,indexStmt,[dti1 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti2 = [formatter stringFromDate:dadosJogo.dtInicioG2];
        sqlite3_bind_text(stmt,indexStmt,[dti2 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti3 = [formatter stringFromDate:dadosJogo.dtInicioG3];
        sqlite3_bind_text(stmt,indexStmt,[dti3 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti4 = [formatter stringFromDate:dadosJogo.dtInicioG4];
        sqlite3_bind_text(stmt,indexStmt,[dti4 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti5 = [formatter stringFromDate:dadosJogo.dtInicioG5];
        sqlite3_bind_text(stmt,indexStmt,[dti5 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti6 = [formatter stringFromDate:dadosJogo.dtFimG1];
        sqlite3_bind_text(stmt,indexStmt,[dti6 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti7 = [formatter stringFromDate:dadosJogo.dtFimG2];
        sqlite3_bind_text(stmt,indexStmt,[dti7 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti8 = [formatter stringFromDate:dadosJogo.dtFimG3];
        sqlite3_bind_text(stmt,indexStmt,[dti8 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti9 = [formatter stringFromDate:dadosJogo.dtFimG4];
        sqlite3_bind_text(stmt,indexStmt,[dti9 UTF8String],-1,nil);
        
        indexStmt ++;
        NSString *dti10 = [formatter stringFromDate:dadosJogo.dtFimG5];
        sqlite3_bind_text(stmt,indexStmt,[dti10 UTF8String],-1,nil);
        
        //dados uteis
        indexStmt ++;
        sqlite3_bind_text(stmt,indexStmt,[dadosJogo.ultimoASacar UTF8String],-1,nil);
        
        indexStmt ++;
        if(dadosJogo.gameAtual < 1){
            dadosJogo.gameAtual = 1;
        }
        sqlite3_bind_int(stmt, indexStmt, dadosJogo.gameAtual);
        
        indexStmt ++;
        NSData *dtArray1 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame1Jogador1];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray1 bytes],[dtArray1 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray2 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame1Jogador2];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray2 bytes],[dtArray2 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray3 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame2Jogador1];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray3 bytes],[dtArray3 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray4 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame2Jogador2];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray4 bytes],[dtArray4 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray5 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame3Jogador1];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray5 bytes],[dtArray5 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray6 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame3Jogador2];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray6 bytes],[dtArray6 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray7 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame4Jogador1];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray7 bytes],[dtArray7 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray8 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame4Jogador2];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray8 bytes],[dtArray8 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray9 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame5Jogador1];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray9 bytes],[dtArray9 length], SQLITE_STATIC);
        
        indexStmt ++;
        NSData *dtArray10 = [NSKeyedArchiver archivedDataWithRootObject:dadosJogo.pontosGame5Jogador2];
        sqlite3_bind_blob(stmt,indexStmt,[dtArray10 bytes],[dtArray10 length], SQLITE_STATIC);
        
        
        //executar
        resultado = sqlite3_step(stmt);
        
        
        if (resultado == SQLITE_DONE) {
            NSLog(@"Jogo Salvo");
        }else{
            NSLog(@"Erro ao Salvar Jogo");
        }
        sqlite3_finalize(stmt);
    }else{
        //NSLog(@"Erro no stmt");
    }
}

-(void)deletar:(DadosJogo*)jogo{
    //SqlDelete
    sqlite3_stmt *stmt;
    int resultado  =  sqlite3_prepare_v2(bancoDeDados, [sqlDelete UTF8String], -1, &stmt, nil);
    if(resultado == SQLITE_OK){
        resultado = sqlite3_step(stmt);
        if (resultado == SQLITE_DONE) {
            NSLog(@"Deletou!!");
        }else{
            NSLog(@"Erro Delecao!!");
        }
        sqlite3_finalize(stmt);
    }else{
        NSLog(@"Erro SatetementDel!!");
    }
}

-(DadosJogo*)consultarFotos:(DadosJogo*)dadosJ{
    
    sqlite3_stmt *stmt;
    
    int resultado = sqlite3_prepare_v2(bancoDeDados, [sqlSelectFotos UTF8String], -1, &stmt, nil);
    
    if (resultado == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            int indexStmt = 0;
            
            const void *ptr = sqlite3_column_blob(stmt,indexStmt);
            int size = sqlite3_column_bytes(stmt, indexStmt);
            
            NSData *teste = [[NSData alloc] initWithBytes:ptr length:size];
            
            if (teste != nil) {
                //conversao
                indexStmt++;
                const void *ptr = sqlite3_column_blob(stmt,indexStmt);
                int size = sqlite3_column_bytes(stmt, indexStmt);
                NSData *img = [[NSData alloc] initWithBytes:ptr length:size];
                dadosJ.imgJogador1 = img != nil ? [UIImage imageWithData:img] : nil;
                
                indexStmt++;
                //conversao
                const void *ptr2 = sqlite3_column_blob(stmt,indexStmt);
                int size2 = sqlite3_column_bytes(stmt, indexStmt);
                NSData *img2 = [[NSData alloc] initWithBytes:ptr2 length:size2];
                dadosJ.imgJogador2 = img != nil ? [UIImage imageWithData:img2] : nil;
            }
        }
    }
    sqlite3_finalize(stmt);
    
    return dadosJ;
}

-(void)deletarFotos:(DadosJogo*)jogo{
    sqlite3_stmt *stmt;
    int resultado  =  sqlite3_prepare_v2(bancoDeDados, [sqlDeleteFotos UTF8String], -1, &stmt, nil);
    if(resultado == SQLITE_OK){
        resultado = sqlite3_step(stmt);
        if (resultado == SQLITE_DONE) {
            NSLog(@"Deletou!!");
        }else{
            NSLog(@"Erro Deletar fotos!!");
        }
        sqlite3_finalize(stmt);
    }else{
        NSLog(@"Erro SatetementDel!!");
    }
}

-(void)salvarFotos:(DadosJogo*) dadosJogo{
    sqlite3_stmt *stmt;
    int resultado = sqlite3_prepare_v2(bancoDeDados,[sqlInsertFotos UTF8String],-1,&stmt,nil);
    
    if(resultado != SQLITE_OK){
        NSLog(@"Erro salvarDadoJogo");
    } else {
        int indexStmt = 1;
        sqlite3_bind_int(stmt, indexStmt, dadosJogo.idObjeto);
        
        indexStmt++;
        NSData *imgData1 = UIImageJPEGRepresentation(dadosJogo.imgJogador1, 1.0);
        sqlite3_bind_blob(stmt, indexStmt,[imgData1 bytes],[imgData1 length], SQLITE_STATIC);
        
        indexStmt++;
        NSData *imgData2 = UIImageJPEGRepresentation(dadosJogo.imgJogador2, 1.0);
        sqlite3_bind_blob(stmt, indexStmt,[imgData2 bytes],[imgData2 length], SQLITE_STATIC);
        
        resultado = sqlite3_step(stmt);
        if (resultado == SQLITE_DONE) {
            NSLog(@"Fotos Salvas");
        }else{
            NSLog(@"Erro ao salvar Fotos");
        }
    }
    sqlite3_finalize(stmt);
}

-(void)salvarDadosSumula:(DadosSumula*)dadosSumula{
    sqlite3_stmt *stmt;
    int resultado = sqlite3_prepare_v2(bancoDeDados,[sqlInsertDadosSumula UTF8String],-1,&stmt,nil);
    
    if(resultado != SQLITE_OK){
        NSLog(@"Erro salvarDadosSumula");
    } else {
        int indexStmt = 1;
        
        sqlite3_bind_int( stmt, indexStmt, dadosSumula.idObjeto);
        indexStmt++;
        sqlite3_bind_text(stmt,indexStmt,[dadosSumula.quadra UTF8String],-1,nil);
        indexStmt++;
        sqlite3_bind_text(stmt,indexStmt,[dadosSumula.marcador UTF8String],-1,nil);
        indexStmt++;
        sqlite3_bind_text(stmt,indexStmt,[dadosSumula.juiz UTF8String],-1,nil);
        
        resultado = sqlite3_step(stmt);
        if (resultado == SQLITE_DONE) {
            NSLog(@"DadosSumula salvos");
        } else {
            NSLog(@"Erro ao salvar DadosSumula");
        }
    }
    
    sqlite3_finalize(stmt);
}

-(DadosSumula*)consultarDadosSumula{
    
    DadosSumula *dados = [DadosSumula alloc];
    
    sqlite3_stmt *stmt;
    
    int resultado = sqlite3_prepare_v2(bancoDeDados, [sqlSelectDadosSumula UTF8String], -1, &stmt, nil);
    
    if (resultado == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int indexStmt = 0;
            
            const void *ptr = sqlite3_column_blob(stmt,indexStmt);
            int size = sqlite3_column_bytes(stmt, indexStmt);
            NSData *teste = [[NSData alloc] initWithBytes:ptr length:size];
            
            if (teste != nil) {
                indexStmt++;
                char *s = (char*)sqlite3_column_text(stmt, indexStmt);
                dados.quadra = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s = (char*)sqlite3_column_text(stmt, indexStmt);
                dados.marcador = s != nil ? [NSString stringWithUTF8String:s] : nil;
                
                indexStmt++;
                s = (char*)sqlite3_column_text(stmt, indexStmt);
                dados.juiz = s != nil ? [NSString stringWithUTF8String:s] : nil;
            }
            
        }
    }
    sqlite3_finalize(stmt);
    
    return dados;
}

-(void)deletarDadosSumula:(DadosSumula*)dadosSumula{
    sqlite3_stmt *stmt;
    int resultado  =  sqlite3_prepare_v2(bancoDeDados, [sqlDeleteDadosSumula UTF8String], -1, &stmt, nil);
    
    if(resultado == SQLITE_OK){
        
        int indexStmt = 0;
        
        sqlite3_bind_int(stmt,indexStmt,dadosSumula.idObjeto);
        resultado = sqlite3_step(stmt);
        
        if (resultado == SQLITE_DONE) {
            NSLog(@"Deletou!!");
            
        }else{
            NSLog(@"Erro deletarDadosSumula!!");
        }
        
    }else{
        NSLog(@"Erro deletarDadosSumula!!");
    }
    
    sqlite3_finalize(stmt);
}


@end
