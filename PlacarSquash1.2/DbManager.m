//
//  DbManager.m
//  Placar Squash
//
//  Created by Adriano on 09/07/16.
//  Copyright © 2016 deBoa. All rights reserved.
//


#import "DBManager.h"
static DBManager *sharedInstance = nil;

static sqlite3 *database = nil;

static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"placar.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            
            //CONFIGURACAO JOGO
            const char *sql_stmt_configuracao = "CREATE TABLE IF NOT EXISTST configuracao (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, id_jogo INTEGER, quadra TEXT, nome_arbitro TEXT, nome_marcador TEXT, campeonato TEXT)";
           
            if (sqlite3_exec(database, sql_stmt_configuracao, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table - configuracao");
            }
            
            // JOGO
            const char *sql_stmt_jogo = "CREATE TABLE IF NOT EXISTST jogo (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, rodada TEXT, jogador1 TEXT, jogador2 TEXT, categoria TEXT, genero TEXT, totalJ1G1 TEXT, totalJ1G2 TEXT, totalJ1G3 TEXT, totalJ1G4 TEXT, totalJ1G5 TEXT, totalJ2G1 TEXT, totalJ2G2 TEXT, totalJ2G3 TEXT, totalJ2G4 TEXT, totalJ2G5 TEXT, totalGames2 TEXT, totalGames1 TEXT, qtdGames INTEGER, vencedorG1 TEXT, vencedorG2 TEXT, vencedorG3 TEXT, vencedorG4 TEXT, vencedorG5 TEXT, dtInicioG1 TEXT, dtInicioG2 TEXT, dtInicioG3 TEXT, dtInicioG4 TEXT, dtInicioG5 TEXT, dtFimG1 TEXT, dtFimG2 TEXT, dtFimG3 TEXT, dtFimG4 TEXT, dtFimG5 TEXT)";
            
            if (sqlite3_exec(database, sql_stmt_jogo, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table - jogo");
            }
            
            // PONTOS GAMES
            const char *sql_stmt_pontos = "CREATE TABLE IF NOT EXISTST pontos (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, id_jogo INTEGER, game INTEGER, jogador INTEGER, ponto TEXT)";
            
            if (sqlite3_exec(database, sql_stmt_pontos, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table - pontos");
            }
            
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveData:(NSString*)registerNumber name:(NSString*)name department:(NSString*)department year:(NSString*)year;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into studentsDetail (regno,name, department, year) values (\"%d\",\"%@\", \"%@\", \"%@\")",[registerNumber integerValue],
                               name, department, year];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSArray*) findByRegisterNumber:(NSString*)registerNumber
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"select name, department, year from studentsDetail where no=\"%@\"",registerNumber];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}
@end
