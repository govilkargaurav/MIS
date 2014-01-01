
#import "DAL.h"
#import "DatabaseBean.h"
#import "GetTrusteesListModel.h"
static sqlite3_stmt *stmt;

@implementation DAL



+ (DAL *) getInstance{
	@try{
		static DAL *instance;
		if(instance == nil) {
			instance = [[DAL alloc] init];
		}
		return instance;
	}@catch (NSException *e) {
		//////NSLog(@"%@",[e description]);
	}
	return nil;
}

- (BOOL) isRecordExistInCountyInfo:(NSString *)countyIDstr{
	BOOL flag=NO;
	@try{
		sqlite3_stmt *statement;
		
		const char *sqlStatement =[[NSString stringWithFormat:@"SELECT * FROM County WHERE propertuID = %@",countyIDstr] cStringUsingEncoding:NSUTF8StringEncoding];
        
        [self openCreateDatabase];
		
		sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil);
		
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			flag=YES;
		}
		sqlite3_close(database);
		return flag;
	}@catch (NSException *e) {
		sqlite3_close(database);
		////NSLog(@"%@",[e description]);
		return flag;
	}
	//sqlite3_close(database);
	return flag;
    
}





/* CHECKINFO SAVE INTO DATABASE */


-(BOOL) insertintocheckinfo:(DatabaseBean *)aBean
{
    
	@try {
		sqlite3_stmt *stmt;
		const char *sqlQuery = "insert into checkInfo (checkNumber,checkAmount) values(?,?)";
        
        
        
		
		if (sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK &&
			sqlite3_bind_text(stmt, 1, [[aBean checkNumber] UTF8String],-1,NULL) == SQLITE_OK &&
			sqlite3_bind_text(stmt, 2, [[aBean checkAmount] UTF8String], -1, NULL) == SQLITE_OK){
			
			int ret = sqlite3_step(stmt);
			if(ret == SQLITE_DONE)
			{
				sqlite3_finalize(stmt);
				sqlite3_close(database);
				//[aBean release];
				return YES;
			}
		}
	}
	@catch (NSException * e)
	{
		sqlite3_close(database);
		//[aBean release];
		////NSLog(@"%@",[e description]);
		////NSLog(@"Error");
	}
	sqlite3_close(database);
	//[aBean release];
	return NO;
}




- (NSString *)getCheckInfoAll:(NSString *)checkNumber
{
    @try{
        NSString *checkAmont;
        sqlite3_stmt *statement;
        [self openCreateDatabase];
        NSString *sqlStatement =[NSString stringWithFormat:@"select checkAmount from checkInfo where checkNumber=%@",checkNumber];
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, nil)==SQLITE_OK){
            //////NSLog(@"Statement Prepared");
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                dataObj=[[DatabaseBean alloc] init];
                if((char *)sqlite3_column_text(statement, 0)!=NULL || (char *)sqlite3_column_text(statement, 0)!=NULL)
                    [dataObj setCheckAmount:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 0)]];
                
                
                checkAmont=dataObj.checkAmount;
            
                
            }
        }
        sqlite3_close(database);
        return checkAmont;
    }@catch (NSException *e) {
        sqlite3_close(database);
        ////NSLog(@"%@",[e description]);
    }
    //sqlite3_close(database);
    return nil;
}



/******************************************************************/

-(BOOL) insertintoCountyInfo:(DatabaseBean *)aBean
{
    
	@try {
		sqlite3_stmt *stmt;
		const char *sqlQuery = "insert into County (propertuID,address,city,state,zip,lattitude,longitude,borrowerfirstname,trusteefirstname,bidderlastname,bidderfirstname,biddermiddlename,maxbid,openingbid,status,updatedby,updatedate,bidderid,wonprice,trusteeId,AuctionId,AuctionDateTime,AuctionNote,legalDescription,countyID,auction_No,crierName,settleStatus,LoanDate,LoanAmount) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        

        
		
		if (sqlite3_prepare_v2(database, sqlQuery, -1, &stmt, NULL) == SQLITE_OK &&
			sqlite3_bind_text(stmt, 1, [[aBean propertyID] UTF8String],-1,NULL) == SQLITE_OK &&
			sqlite3_bind_text(stmt, 2, [[aBean addressStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 3, [[aBean cityStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 4, [[aBean stateStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 5, [[aBean zipStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 6, [[aBean latitudeStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 7, [[aBean longitudeStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 8,  [[aBean borrowerName] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 9, [[aBean trusteeFirstNameStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 10, [[aBean bidderlastName] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 11, [[aBean bidderFirstName] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 12, [[aBean biddermiddleName] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 13, [[aBean maxBidStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 14, [[aBean openingbidStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 15, [[aBean statusStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 16, [[aBean updatedbyStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 17, [[aBean updatedateStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 18, [[aBean bidderidStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 19, [[aBean wonpriceStr] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 20, [[aBean truseeId] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 21, [[aBean AuctionId] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 22, [[aBean AuctionDateTime] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 23, [[aBean AuctionNote] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 24, [[aBean legalDescription] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 25, [[aBean countyID] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 26, [[aBean auctionNumber] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 27, [[aBean crierName] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 28, [[aBean settleStatus] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 29, [[aBean loanDate] UTF8String], -1, NULL) == SQLITE_OK &&
            sqlite3_bind_text(stmt, 30, [[aBean loanAmount] UTF8String], -1, NULL) == SQLITE_OK){
			
			int ret = sqlite3_step(stmt);
			if(ret == SQLITE_DONE)
			{
				sqlite3_finalize(stmt);
				sqlite3_close(database);
				//[aBean release];
				return YES;
			}
		}
	}
	@catch (NSException * e)
	{
		sqlite3_close(database);
		//[aBean release];
		////NSLog(@"%@",[e description]);
		////NSLog(@"Error");
	}
	sqlite3_close(database);
	//[aBean release];
	return NO;
}





- (NSMutableArray *)getAllSubCategory:(NSString *)countyID
{
    @try{
        sqlite3_stmt *statement;
        [self openCreateDatabase];
        NSMutableDictionary *array=[[NSMutableDictionary alloc] init];
        NSMutableArray *arrayDic=[[NSMutableArray alloc] init];
        NSString *sqlStatement =[NSString stringWithFormat:@"select propertuID,address,city,state,zip,lattitude,longitude,borrowerfirstname,trusteefirstname,trusteeId,bidderlastname,bidderfirstname,biddermiddlename,maxbid,openingbid,status,updatedby,updatedate,bidderid,wonprice,AuctionId,AuctionDateTime,AuctionNote,legalDescription,countyID,auction_No,crierName,settleStatus,LoanDate,LoanAmount from County where countyID=%@",countyID];
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, nil)==SQLITE_OK){
            //////NSLog(@"Statement Prepared");
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                dataObj=[[DatabaseBean alloc] init];
                if((char *)sqlite3_column_text(statement, 0)!=NULL || (char *)sqlite3_column_text(statement, 0)!=NULL)
                    [dataObj setPropertyID:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 0)]];
                if((char *)sqlite3_column_text(statement, 1)!=NULL || (char *)sqlite3_column_text(statement, 1)!=NULL)
                    [dataObj setAddressStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                if((char *)sqlite3_column_text(statement, 2)!=NULL || (char *)sqlite3_column_text(statement, 2)!=NULL)
                    [dataObj setCityStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                if((char *)sqlite3_column_text(statement, 3)!=NULL || (char *)sqlite3_column_text(statement, 3)!=NULL)
                    [dataObj setStateStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                if((char *)sqlite3_column_text(statement, 4)!=NULL || (char *)sqlite3_column_text(statement, 4)!=NULL)
                    [dataObj setZipStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                if((char *)sqlite3_column_text(statement, 5)!=NULL || (char *)sqlite3_column_text(statement, 5)!=NULL)
                    [dataObj setLatitudeStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                if((char *)sqlite3_column_text(statement, 6)!=NULL || (char *)sqlite3_column_text(statement, 6)!=NULL)
                    [dataObj setLongitudeStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 6)]];
                if((char *)sqlite3_column_text(statement, 7)!=NULL || (char *)sqlite3_column_text(statement, 7)!=NULL)
                    [dataObj setBorrowerName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 7)]];
                if((char *)sqlite3_column_text(statement, 8)!=NULL || (char *)sqlite3_column_text(statement, 8)!=NULL)
                    [dataObj setTrusteeFirstNameStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 8)]];
                if((char *)sqlite3_column_text(statement, 9)!=NULL || (char *)sqlite3_column_text(statement, 9)!=NULL)
                    [dataObj setTruseeId:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                if((char *)sqlite3_column_text(statement, 10)!=NULL || (char *)sqlite3_column_text(statement, 10)!=NULL)
                    [dataObj setBidderlastName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                if((char *)sqlite3_column_text(statement, 11)!=NULL || (char *)sqlite3_column_text(statement, 11)!=NULL)
                    [dataObj setBidderFirstName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 11)]];
                if((char *)sqlite3_column_text(statement, 12)!=NULL || (char *)sqlite3_column_text(statement, 12)!=NULL)
                    [dataObj setBiddermiddleName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 12)]];
                if((char *)sqlite3_column_text(statement, 13)!=NULL || (char *)sqlite3_column_text(statement, 13)!=NULL)
                    [dataObj setMaxBidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 13)]];
                if((char *)sqlite3_column_text(statement, 14)!=NULL || (char *)sqlite3_column_text(statement, 14)!=NULL)
                    [dataObj setOpeningbidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 14)]];
                if((char *)sqlite3_column_text(statement, 15)!=NULL || (char *)sqlite3_column_text(statement, 15)!=NULL)
                    [dataObj setStatusStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 15)]];
                if((char *)sqlite3_column_text(statement, 16)!=NULL || (char *)sqlite3_column_text(statement, 16)!=NULL)
                    [dataObj setUpdatedbyStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 16)]];
                if((char *)sqlite3_column_text(statement, 17)!=NULL || (char *)sqlite3_column_text(statement, 17)!=NULL)
                    [dataObj setUpdatedateStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 17)]];
                if((char *)sqlite3_column_text(statement, 18)!=NULL || (char *)sqlite3_column_text(statement, 18)!=NULL)
                    [dataObj setBidderidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 18)]];
                if((char *)sqlite3_column_text(statement, 19)!=NULL || (char *)sqlite3_column_text(statement, 19)!=NULL)
                    [dataObj setWonpriceStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 19)]];
                if((char *)sqlite3_column_text(statement, 20)!=NULL || (char *)sqlite3_column_text(statement, 20)!=NULL)
                    [dataObj setAuctionId:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 20)]];
                if((char *)sqlite3_column_text(statement, 21)!=NULL || (char *)sqlite3_column_text(statement, 21)!=NULL)
                    [dataObj setAuctionDateTime:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 21)]];
                if((char *)sqlite3_column_text(statement, 22)!=NULL || (char *)sqlite3_column_text(statement, 22)!=NULL)
                    [dataObj setAuctionNote:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 22)]];
                if((char *)sqlite3_column_text(statement, 23)!=NULL || (char *)sqlite3_column_text(statement, 23)!=NULL)
                    [dataObj setLegalDescription:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 23)]];
                if((char *)sqlite3_column_text(statement, 24)!=NULL || (char *)sqlite3_column_text(statement, 24)!=NULL)
                    [dataObj setCountyID:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 24)]];
                if((char *)sqlite3_column_text(statement, 25)!=NULL || (char *)sqlite3_column_text(statement, 25)!=NULL)
                    [dataObj setAuctionNumber:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 25)]];
                if((char *)sqlite3_column_text(statement, 26)!=NULL || (char *)sqlite3_column_text(statement, 26)!=NULL)
                    [dataObj setCrierName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 26)]];
                if((char *)sqlite3_column_text(statement, 27)!=NULL || (char *)sqlite3_column_text(statement, 27)!=NULL)
                    [dataObj setSettleStatus:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 27)]];
                if((char *)sqlite3_column_text(statement, 28)!=NULL || (char *)sqlite3_column_text(statement, 28)!=NULL)
                    [dataObj setLoanDate:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 28)]];
                if((char *)sqlite3_column_text(statement, 29)!=NULL || (char *)sqlite3_column_text(statement, 29)!=NULL)
                    [dataObj setLoanAmount:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 29)]];
                
                
                
                array=[NSDictionary dictionaryWithObjectsAndKeys:dataObj.propertyID,@"ID",dataObj.addressStr,@"ADDRESS",dataObj.cityStr,@"CITY",dataObj.stateStr,@"STATE",dataObj.borrowerName,@"BROOWER_NAME",dataObj.trusteeFirstNameStr,@"TRUSTEE_NAME",dataObj.truseeId,@"TRUSTEE_ID",dataObj.updatedateStr,@"DATE",dataObj.openingbidStr,@"OPENING_BID",dataObj.statusStr,@"STATUS",dataObj.maxBidStr,@"MAX_BID",dataObj.wonpriceStr,@"WON_PRIZE",dataObj.AuctionId,@"AUCTION_ID",dataObj.AuctionDateTime,@"AUCTION_DATE_TIME",dataObj.AuctionNote,@"AUCTION_NOTE",dataObj.legalDescription,@"LEGAL_DESCRIPTION",dataObj.countyID,@"COUNTY_ID",dataObj.auctionNumber,@"AUCTION_NUMBER",dataObj.crierName,@"CRIER_NAME",dataObj.settleStatus,@"SETTLE_STATUS",dataObj.loanDate,@"LOANDATE",dataObj.loanAmount,@"LOANAMOUNT", nil];

                

                
                [arrayDic addObject:array];
                
            }
        }
        sqlite3_close(database);
        return arrayDic;
    }@catch (NSException *e) {
        sqlite3_close(database);
        ////NSLog(@"%@",[e description]);
    }
    //sqlite3_close(database);
    return nil;
}



- (NSMutableDictionary *)getAllSubCategorybyId:(NSString *)propertyID:(NSString *)queryString
{
    @try{
        sqlite3_stmt *statement;
        [self openCreateDatabase];
        NSMutableDictionary *array=[[NSMutableDictionary alloc] init];

        databaseArray=[[NSMutableArray alloc] init];
        NSString *sqlStatement =[NSString stringWithFormat:@"%@%@",queryString,propertyID];
        
        ////NSLog(@"%@",sqlStatement);
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, nil)==SQLITE_OK){
            //////NSLog(@"Statement Prepared");
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                dataObj=[[DatabaseBean alloc] init];
                if((char *)sqlite3_column_text(statement, 0)!=NULL || (char *)sqlite3_column_text(statement, 0)!=NULL)
                    [dataObj setPropertyID:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 0)]];
                if((char *)sqlite3_column_text(statement, 1)!=NULL || (char *)sqlite3_column_text(statement, 1)!=NULL)
                    [dataObj setAddressStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                if((char *)sqlite3_column_text(statement, 2)!=NULL || (char *)sqlite3_column_text(statement, 2)!=NULL)
                    [dataObj setCityStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                if((char *)sqlite3_column_text(statement, 3)!=NULL || (char *)sqlite3_column_text(statement, 3)!=NULL)
                    [dataObj setStateStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                if((char *)sqlite3_column_text(statement, 4)!=NULL || (char *)sqlite3_column_text(statement, 4)!=NULL)
                    [dataObj setZipStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                if((char *)sqlite3_column_text(statement, 5)!=NULL || (char *)sqlite3_column_text(statement, 5)!=NULL)
                    [dataObj setLatitudeStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                if((char *)sqlite3_column_text(statement, 6)!=NULL || (char *)sqlite3_column_text(statement, 6)!=NULL)
                    [dataObj setLongitudeStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 6)]];
                if((char *)sqlite3_column_text(statement, 7)!=NULL || (char *)sqlite3_column_text(statement, 7)!=NULL)
                    [dataObj setBorrowerName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 7)]];
                if((char *)sqlite3_column_text(statement, 8)!=NULL || (char *)sqlite3_column_text(statement, 8)!=NULL)
                    [dataObj setTrusteeFirstNameStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 8)]];
                if((char *)sqlite3_column_text(statement, 9)!=NULL || (char *)sqlite3_column_text(statement, 9)!=NULL)
                    [dataObj setTruseeId:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                if((char *)sqlite3_column_text(statement, 10)!=NULL || (char *)sqlite3_column_text(statement, 10)!=NULL)
                    [dataObj setBidderlastName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                if((char *)sqlite3_column_text(statement, 11)!=NULL || (char *)sqlite3_column_text(statement, 11)!=NULL)
                    [dataObj setBidderFirstName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 11)]];
                if((char *)sqlite3_column_text(statement, 12)!=NULL || (char *)sqlite3_column_text(statement, 12)!=NULL)
                    [dataObj setBiddermiddleName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 12)]];
                if((char *)sqlite3_column_text(statement, 13)!=NULL || (char *)sqlite3_column_text(statement, 13)!=NULL)
                    [dataObj setMaxBidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 13)]];
                if((char *)sqlite3_column_text(statement, 14)!=NULL || (char *)sqlite3_column_text(statement, 14)!=NULL)
                    [dataObj setOpeningbidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 14)]];
                if((char *)sqlite3_column_text(statement, 15)!=NULL || (char *)sqlite3_column_text(statement, 15)!=NULL)
                    [dataObj setStatusStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 15)]];
                if((char *)sqlite3_column_text(statement, 16)!=NULL || (char *)sqlite3_column_text(statement, 16)!=NULL)
                    [dataObj setUpdatedbyStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 16)]];
                if((char *)sqlite3_column_text(statement, 17)!=NULL || (char *)sqlite3_column_text(statement, 17)!=NULL)
                    [dataObj setUpdatedateStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 17)]];
                if((char *)sqlite3_column_text(statement, 18)!=NULL || (char *)sqlite3_column_text(statement, 18)!=NULL)
                    [dataObj setBidderidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 18)]];
                if((char *)sqlite3_column_text(statement, 19)!=NULL || (char *)sqlite3_column_text(statement, 19)!=NULL)
                    [dataObj setWonpriceStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 19)]];
                if((char *)sqlite3_column_text(statement, 20)!=NULL || (char *)sqlite3_column_text(statement, 20)!=NULL)
                    [dataObj setAuctionId:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 20)]];
                if((char *)sqlite3_column_text(statement, 21)!=NULL || (char *)sqlite3_column_text(statement, 21)!=NULL)
                    [dataObj setAuctionDateTime:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 21)]];
                if((char *)sqlite3_column_text(statement, 22)!=NULL || (char *)sqlite3_column_text(statement, 22)!=NULL)
                    [dataObj setAuctionNote:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 22)]];
                if((char *)sqlite3_column_text(statement, 23)!=NULL || (char *)sqlite3_column_text(statement, 23)!=NULL)
                    [dataObj setLegalDescription:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 23)]];
                if((char *)sqlite3_column_text(statement, 24)!=NULL || (char *)sqlite3_column_text(statement, 24)!=NULL)
                    [dataObj setAuctionNumber:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 24)]];
                if((char *)sqlite3_column_text(statement, 25)!=NULL || (char *)sqlite3_column_text(statement, 25)!=NULL)
                    [dataObj setCrierName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 25)]];
                if((char *)sqlite3_column_text(statement, 26)!=NULL || (char *)sqlite3_column_text(statement, 26)!=NULL)
                    [dataObj setSettleStatus:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 26)]];
                if((char *)sqlite3_column_text(statement, 27)!=NULL || (char *)sqlite3_column_text(statement, 27)!=NULL)
                    [dataObj setLoanDate:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 27)]];
                if((char *)sqlite3_column_text(statement, 28)!=NULL || (char *)sqlite3_column_text(statement, 28)!=NULL)
                    [dataObj setLoanAmount:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 28)]];
                
                array=[NSDictionary dictionaryWithObjectsAndKeys:dataObj.propertyID,@"ID",dataObj.addressStr,@"ADDRESS",dataObj.cityStr,@"CITY",dataObj.stateStr,@"STATE",dataObj.borrowerName,@"BROOWER_NAME",dataObj.trusteeFirstNameStr,@"TRUSTEE_NAME",dataObj.truseeId,@"TRUSTEE_ID",dataObj.updatedateStr,@"DATE",dataObj.openingbidStr,@"OPENING_BID",dataObj.statusStr,@"STATUS",dataObj.maxBidStr,@"MAX_BID",dataObj.wonpriceStr,@"WON_PRIZE",dataObj.AuctionId,@"AUCTION_ID",dataObj.AuctionDateTime,@"AUCTION_DATE_TIME",dataObj.legalDescription,@"LEGAL_DESCRIPTION",dataObj.AuctionNote,@"AUCTION_NOTE",dataObj.AuctionId,@"AUCTION_ID",dataObj.auctionNumber,@"AUCTION_NUMBER",dataObj.crierName,@"CRIER_NAME",dataObj.settleStatus,@"SETTLE_STATUS",dataObj.loanDate,@"LOANDATE",dataObj.loanAmount,@"LOANAMOUNT", nil];
                
                
   
               
                [databaseArray addObject:array];
                
                //[dataObj release];
                
            }
        }
        sqlite3_close(database);
        return array;
    }@catch (NSException *e) {
        sqlite3_close(database);
        ////NSLog(@"%@",[e description]);
    }
    //sqlite3_close(database);
    return nil;
}



- (NSMutableDictionary *)getAllSubCategorybyPropertyID:(NSString *)propertyID:(NSString *)queryString
{
    @try{
        sqlite3_stmt *statement;
        [self openCreateDatabase];
        NSMutableDictionary *array=[[NSMutableDictionary alloc] init];
        
        databaseArray=[[NSMutableArray alloc] init];
        NSString *sqlStatement =[NSString stringWithFormat:@"%@%@",queryString,propertyID];
        
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, nil)==SQLITE_OK){
            //////NSLog(@"Statement Prepared");
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                dataObj=[[DatabaseBean alloc] init];
                if((char *)sqlite3_column_text(statement, 0)!=NULL || (char *)sqlite3_column_text(statement, 0)!=NULL)
                    [dataObj setPropertyID:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 0)]];
                if((char *)sqlite3_column_text(statement, 1)!=NULL || (char *)sqlite3_column_text(statement, 1)!=NULL)
                    [dataObj setAddressStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                if((char *)sqlite3_column_text(statement, 2)!=NULL || (char *)sqlite3_column_text(statement, 2)!=NULL)
                    [dataObj setCityStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 2)]];
                if((char *)sqlite3_column_text(statement, 3)!=NULL || (char *)sqlite3_column_text(statement, 3)!=NULL)
                    [dataObj setStateStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 3)]];
                if((char *)sqlite3_column_text(statement, 4)!=NULL || (char *)sqlite3_column_text(statement, 4)!=NULL)
                    [dataObj setZipStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 4)]];
                if((char *)sqlite3_column_text(statement, 5)!=NULL || (char *)sqlite3_column_text(statement, 5)!=NULL)
                    [dataObj setLatitudeStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 5)]];
                if((char *)sqlite3_column_text(statement, 6)!=NULL || (char *)sqlite3_column_text(statement, 6)!=NULL)
                    [dataObj setLongitudeStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 6)]];
                if((char *)sqlite3_column_text(statement, 7)!=NULL || (char *)sqlite3_column_text(statement, 7)!=NULL)
                    [dataObj setBorrowerName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 7)]];
                if((char *)sqlite3_column_text(statement, 8)!=NULL || (char *)sqlite3_column_text(statement, 8)!=NULL)
                    [dataObj setTrusteeFirstNameStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 8)]];
                if((char *)sqlite3_column_text(statement, 9)!=NULL || (char *)sqlite3_column_text(statement, 9)!=NULL)
                    [dataObj setTruseeId:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 9)]];
                if((char *)sqlite3_column_text(statement, 10)!=NULL || (char *)sqlite3_column_text(statement, 10)!=NULL)
                    [dataObj setBidderlastName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 10)]];
                if((char *)sqlite3_column_text(statement, 11)!=NULL || (char *)sqlite3_column_text(statement, 11)!=NULL)
                    [dataObj setBidderFirstName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 11)]];
                if((char *)sqlite3_column_text(statement, 12)!=NULL || (char *)sqlite3_column_text(statement, 12)!=NULL)
                    [dataObj setBiddermiddleName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 12)]];
                if((char *)sqlite3_column_text(statement, 13)!=NULL || (char *)sqlite3_column_text(statement, 13)!=NULL)
                    [dataObj setMaxBidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 13)]];
                if((char *)sqlite3_column_text(statement, 14)!=NULL || (char *)sqlite3_column_text(statement, 14)!=NULL)
                    [dataObj setOpeningbidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 14)]];
                if((char *)sqlite3_column_text(statement, 15)!=NULL || (char *)sqlite3_column_text(statement, 15)!=NULL)
                    [dataObj setStatusStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 15)]];
                if((char *)sqlite3_column_text(statement, 16)!=NULL || (char *)sqlite3_column_text(statement, 16)!=NULL)
                    [dataObj setUpdatedbyStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 16)]];
                if((char *)sqlite3_column_text(statement, 17)!=NULL || (char *)sqlite3_column_text(statement, 17)!=NULL)
                    [dataObj setUpdatedateStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 17)]];
                if((char *)sqlite3_column_text(statement, 18)!=NULL || (char *)sqlite3_column_text(statement, 18)!=NULL)
                    [dataObj setBidderidStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 18)]];
                if((char *)sqlite3_column_text(statement, 19)!=NULL || (char *)sqlite3_column_text(statement, 19)!=NULL)
                    [dataObj setWonpriceStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 19)]];
                if((char *)sqlite3_column_text(statement, 20)!=NULL || (char *)sqlite3_column_text(statement, 20)!=NULL)
                    [dataObj setAuctionId:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 20)]];
                if((char *)sqlite3_column_text(statement, 21)!=NULL || (char *)sqlite3_column_text(statement, 21)!=NULL)
                    [dataObj setAuctionDateTime:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 21)]];
                if((char *)sqlite3_column_text(statement, 22)!=NULL || (char *)sqlite3_column_text(statement, 22)!=NULL)
                    [dataObj setAuctionNote:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 22)]];
                if((char *)sqlite3_column_text(statement, 23)!=NULL || (char *)sqlite3_column_text(statement, 23)!=NULL)
                    [dataObj setLegalDescription:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 23)]];
                if((char *)sqlite3_column_text(statement, 24)!=NULL || (char *)sqlite3_column_text(statement, 24)!=NULL)
                    [dataObj setAuctionNumber:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 24)]];
                if((char *)sqlite3_column_text(statement, 25)!=NULL || (char *)sqlite3_column_text(statement, 25)!=NULL)
                    [dataObj setCrierName:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 25)]];
                if((char *)sqlite3_column_text(statement, 26)!=NULL || (char *)sqlite3_column_text(statement, 26)!=NULL)
                    [dataObj setSettleStatus:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 26)]];
                if((char *)sqlite3_column_text(statement, 27)!=NULL || (char *)sqlite3_column_text(statement, 27)!=NULL)
                    [dataObj setLoanDate:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 27)]];
                if((char *)sqlite3_column_text(statement, 28)!=NULL || (char *)sqlite3_column_text(statement, 28)!=NULL)
                    [dataObj setLoanAmount:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 28)]];
                
                array=[NSDictionary dictionaryWithObjectsAndKeys:dataObj.propertyID,@"ID",dataObj.addressStr,@"ADDRESS",dataObj.cityStr,@"CITY",dataObj.stateStr,@"STATE",dataObj.borrowerName,@"BROOWER_NAME",dataObj.trusteeFirstNameStr,@"TRUSTEE_NAME",dataObj.truseeId,@"TRUSTEE_ID",dataObj.updatedateStr,@"DATE",dataObj.openingbidStr,@"OPENING_BID",dataObj.statusStr,@"STATUS",dataObj.maxBidStr,@"MAX_BID",dataObj.wonpriceStr,@"WON_PRIZE",dataObj.AuctionId,@"AUCTION_ID",dataObj.AuctionDateTime,@"AUCTION_DATE_TIME",dataObj.legalDescription,@"LEGAL_DESCRIPTION",dataObj.AuctionNote,@"AUCTION_NOTE",dataObj.AuctionId,@"AUCTION_ID",dataObj.auctionNumber,@"AUCTION_NUMBER",dataObj.crierName,@"CRIER_NAME",dataObj.settleStatus,@"SETTLE_STATUS",dataObj.loanDate,@"LOANDATE",dataObj.loanAmount,@"LOANAMOUNT", nil];
                
                
                
                //[dataObj release];
                
            }
        }
        sqlite3_close(database);
        return array;
    }@catch (NSException *e) {
        sqlite3_close(database);
        ////NSLog(@"%@",[e description]);
    }
    //sqlite3_close(database);
    return nil;
}





- (NSMutableDictionary *)getAllSubCategorybyId1:(NSString *)queryString
{
    @try{
        sqlite3_stmt *statement;
        [self openCreateDatabase];
        NSMutableDictionary *array=[[NSMutableDictionary alloc] init];
        
        databaseArray=[[NSMutableArray alloc] init];
        NSString *sqlStatement =[NSString stringWithFormat:@"%@",queryString];
        
        
        
        if(sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, nil)==SQLITE_OK){
            //////NSLog(@"Statement Prepared");
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                dataObj=[[DatabaseBean alloc] init];
               
                if((char *)sqlite3_column_text(statement, 1)!=NULL || (char *)sqlite3_column_text(statement, 1)!=NULL)
                    [dataObj setTrusteeFirstNameStr:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 1)]];
                if((char *)sqlite3_column_text(statement, 0)!=NULL || (char *)sqlite3_column_text(statement, 0)!=NULL)
                    [dataObj setTruseeId:[[NSString alloc] initWithUTF8String: (char *)sqlite3_column_text(statement, 0)]];
               
                
                array=[NSDictionary dictionaryWithObjectsAndKeys:dataObj.trusteeFirstNameStr,@"TRUSTEE_NAME",dataObj.truseeId,@"TRUSTEE_ID", nil];
                
                
                
                
                [databaseArray addObject:array];
                
                //[dataObj release];
                
            }
        }
        sqlite3_close(database);
        return array;
    }@catch (NSException *e) {
        sqlite3_close(database);
    }
    //sqlite3_close(database);
    return nil;
}



- (BOOL) deleteAllrecords:(NSString *)QueryStr{
	@try{
		stmt=nil;
		if(stmt==nil){
            
            
            
            
            NSString *sqlQuery=[NSString stringWithFormat:@"%@",QueryStr];
            
            [self openCreateDatabase];
            
            if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &stmt, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating Insert statement. '%s'", sqlite3_errmsg(database));
            }
			//const char *query = [[NSString stringWithFormat:@"delete from tbl_category_Draw"] cStringUsingEncoding:NSUTF8StringEncoding];
			
			//if(sqlite3_prepare_v2(database, query, -1, &stmt, NULL) == SQLITE_OK){
            if (SQLITE_DONE != sqlite3_step(stmt)){
                NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
                sqlite3_reset(stmt);
                return NO;
            }
            return YES;
            sqlite3_reset(stmt);
			//}else{
			//	return NO;
			//}
		}else{
			return NO;
		}
	}@catch(NSException *e){
		sqlite3_close(database);
		//////NSLog(@"%@",[e description]);
		//////NSLog(@"Error");
	}
	return NO;	
}


-(void) openCreateDatabase {
	@try{
		databasePath=[self dataFilePath];
		[self createEditableCopyOfDatabaseIfNeeded];
		if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK) { 
			sqlite3_close(database);
			NSAssert(0, @"Failed to open database");
		}
	}@catch (NSException *e) {
		////NSLog(@"%@",[e description]);

	}
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
	@try{
		BOOL success;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSError *error;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
		success = [fileManager fileExistsAtPath:writableDBPath];
		if (success) return;
		// The writable database does not exist, so copy the default to the appropriate location.
		////NSLog(@"database not exist, therefore create here...");
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}		
	}@catch (NSException *e) {
		////NSLog(@"%@",[e description]);
	}
    // First, test for existence.
 }

// Returns Database file path
- (NSString *) dataFilePath {
	@try{
		// Get the path to the documents directory and append the databaseName
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		databasePath = [documentsDir stringByAppendingPathComponent:dbName];
		return databasePath;		
	}@catch (NSException *e) {
		////NSLog(@"%@",[e description]);
	}
	return nil;
}
@end

