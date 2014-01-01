//
//  webService.m
//  ZawJi
//
//  Created by openxcell open on 11/16/10.
//  Copyright 2010 xcsxzc. All rights reserved.
//

#import "webService.h"

//static NSString *webServiceURL = @"";

@implementation webService
+(NSMutableURLRequest*)getURq_getansascreen:(NSString*)ws_name action:(NSString*)sa_Name message:(NSString*)sm_msg{
	NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:ws_name] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
	
	[urlReq addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlReq addValue:sa_Name forHTTPHeaderField:@"SOAPAction"];
	[urlReq setHTTPMethod:@"POST"];
	[urlReq setHTTPBody:[sm_msg dataUsingEncoding:NSUTF8StringEncoding]];
	return urlReq;
}


#pragma mark - Access Token
//---------------------------------------------------------------------------------------
+(NSString*)getWS_accessToken{
	return App_URL;
}
+(NSString*)getSA_accessToken{
	return App_URL;
}
+(NSString*)getSM_accessToken{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getAccessTokenSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:soapIn>"
										 "<tns:random>a</tns:random>"
										 "</tns:soapIn>"
										 "</tns:getAccessTokenSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>"]; 
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_Login{
	return App_URL;
}
+(NSString*)getSA_Login{
	return App_URL;
}
+(NSString*)getSM_Login:(NSString*)txtUname Password:(NSString*)txtPass AccessToken:(NSString*)accessToken{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:loginUserSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:userName>%@</tns:userName>"
										 "<tns:passWord>%@</tns:passWord>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "</tns:loginUserSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",txtUname,txtPass,accessToken];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_Register
{
	return App_URL;
}
+(NSString*)getSA_Register
{
	return App_URL;
}
+(NSString*)getSM_Register:(NSString*)UName FirstName:(NSString*)FName LastName:(NSString*)LName EMail:(NSString*)Email Password:(NSString*)Pass
{
    NSString *timeZone = @"UP4";
    NSString *Language = @"en";
    NSString *Country = @"101";
    //[[NSString stringWithFormat:@"%@",[NSTimeZone systemTimeZone].abbreviation] retain];
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:registerUserSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:soapIn>"
										 "<tns:userData>"
                                         "<tns:userName>%@</tns:userName>"
                                         "<tns:firstName>%@</tns:firstName>"
                                         "<tns:lastName>%@</tns:lastName>"
                                         "<tns:timeZone>%@</tns:timeZone>"
                                         "<tns:language>%@</tns:language>"
                                         "<tns:email>%@</tns:email>"
                                         "<tns:country>%@</tns:country>"
                                         "<tns:password>%@</tns:password>"
										 "</tns:userData>"
										 "</tns:soapIn>"
										 "<tns:appSecrete>myapplicationsecrete</tns:appSecrete>"
										 "<tns:appName>ipad</tns:appName>"
										 "</tns:registerUserSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",UName,FName,LName,timeZone,Language,Email,Country,Pass];
    
    return mStrdownloadSoapMessage;
}
//---------------------------------------------------------------------------------------

+(NSString*)getWS_UserSetting{
	return App_URL;
}
+(NSString*)getSA_UserSetting{
	return App_URL;
}
+(NSString*)getSM_UserSetting:(NSString*)Token Ack:(NSString*)Ackno{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getUserSettingsSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:settingType>ALL</tns:settingType>"
										 "</tns:soapIn>"
										 "</tns:getUserSettingsSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno];
	return mStrdownloadSoapMessage;
        
}
//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetList{
	return App_URL;
}
+(NSString*)getSA_GetList{
	return App_URL;
}
+(NSString*)getSM_GetList:(NSString*)Token Ack:(NSString*)Ackno{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getListsSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:listCateType></tns:listCateType>"
										 "</tns:soapIn>"
										 "</tns:getListsSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetTaskDesc{
	return App_URL;
}
+(NSString*)getSA_GetTaskDesc{
	return App_URL;
}
+(NSString*)getSM_GetTaskDesc:(NSString*)Token Ack:(NSString*)Ackno{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getTasksSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:taskTypes>GENEREL</tns:taskTypes>"
										 "</tns:soapIn>"
										 "</tns:getTasksSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno];
	return mStrdownloadSoapMessage;
}


//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetOwnCont{
	return App_URL;
}
+(NSString*)getSA_GetOwnCont{
	return App_URL;
}
+(NSString*)getSM_GetOwnCont:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)UserId{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getOwnContactsSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>%@</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getOwnContactsSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,UserId];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------


+(NSString*)getWS_GetOrgCont{
	return App_URL;
}
+(NSString*)getSA_GetOrgCont{
	return App_URL;
}
+(NSString*)getSM_GetOrgCont:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)Userid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getOrgContactsSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>%@</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getOrgContactsSoapInPart>"
										 "</SOAP-ENV:Body></SOAP-ENV:Envelope>",Token,Ackno,Userid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetMessage{
	return App_URL;
}
+(NSString*)getSA_GetMessage{
	return App_URL;
}
+(NSString*)getSM_GetMessage:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)Userid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getMessagesSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>%@</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getMessagesSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,Userid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetChannel{
	return App_URL;
}
+(NSString*)getSA_GetChannel{
	return App_URL;
}
+(NSString*)getSM_GetChannel:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)Userid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getChannelsSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>%@</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getChannelsSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,Userid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetTimeZone{
	return App_URL;
}
+(NSString*)getSA_GetTimeZone{
	return App_URL;
}
+(NSString*)getSM_GetTimeZone:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)Userid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getTimeZonesSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>227</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getTimeZonesSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno];//,Userid];
    return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetStandardReminder{
	return App_URL;
}
+(NSString*)getSA_GetStandardReminder{
	return App_URL;
}
+(NSString*)getSM_GetStandardReminder:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)Userid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getStanderdReminderSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>%@</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getStanderdReminderSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,Userid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetReminders{
	return App_URL;
}
+(NSString*)getSA_GetReminders{
	return App_URL;
}
+(NSString*)getSM_GetReminders:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)Userid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getRemindersSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>%@</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getRemindersSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,Userid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_GetCountries{
	return App_URL;
}
+(NSString*)getSA_GetCountries{
	return App_URL;
}
+(NSString*)getSM_GetCountries:(NSString*)Token Ack:(NSString*)Ackno userId:(NSString*)Userid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:getCountriesSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:userId>%@</tns:userId>"
										 "</tns:soapIn>"
										 "</tns:getCountriesSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,Userid];
	return mStrdownloadSoapMessage;
}

#pragma mark - POST List WS
//---------------------------------------------------------------------------------------

+(NSString*)getWS_PostList{
	return App_URL;
}
+(NSString*)getSA_PostList{
	return App_URL;
}
+(NSString*)getSM_PostList:(NSString*)Token Ack:(NSString*)Ackno listName:(NSString*)listname{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:createListSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:listName>%@</tns:listName>"
										 "</tns:soapIn>"
										 "</tns:createListSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,listname];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_PostUpdateList{
	return App_URL;
}
+(NSString*)getSA_PostUpdateList{
	return App_URL;
}
+(NSString*)getSM_PostUpdateList:(NSString*)Token Ack:(NSString*)Ackno listName:(NSString*)listname listId:(NSString*)listid listCategory:(NSString*)listcategory{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:updateListSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:list>"
										 "<tns:listName>%@</tns:listName>"
										 "<tns:listId>%@</tns:listId>"
										 "<tns:listCategory>%@</tns:listCategory>"
										 "</tns:list>"
										 "</tns:soapIn>"
										 "</tns:updateListSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",Token,Ackno,listname,listid,listcategory];
	return mStrdownloadSoapMessage;
}



//---------------------------------------------------------------------------------------

+(NSString*)getWS_DeleteList
{
	return App_URL;
}
+(NSString*)getSA_DeleteList
{
	return App_URL;
}
+(NSString*)getSM_DeleteList:(NSString*)AccessToken Ack:(NSString*)ACK ListId:(NSString*)listId
{
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:deleteListSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:listId>%@</tns:listId>"
										 "</tns:soapIn>"
										 "</tns:deleteListSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",AccessToken,ACK,listId];
	return mStrdownloadSoapMessage;
}

#pragma mark - PostTask WS
//---------------------------------------------------------------------------------------

+(NSString*)getWS_PostTaskWOR{
	return App_URL;
}
+(NSString*)getSA_PostTaskWOR{
	return App_URL;
}
+(NSString*)getSM_PostTaskWOR:(NSString*)AccessToken Ack:(NSString*)ACK Priority:(NSString*)priority Description:(NSString*)desc dueDate:(NSString*)duedate listId:(NSString*)listid assignId:(NSString*)assignid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
                                         "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
                                         "<SOAP-ENV:Body>"
                                         "<tns:createTaskSoapInPart xmlns:tns=\"http://tempuri.org/\">"
                                         "<tns:credential>"
                                         "<tns:accesToken>%@</tns:accesToken>"
                                         "<tns:ACK>%@</tns:ACK>"
                                         "</tns:credential>"
                                         "<tns:soapIn>"
                                         "<tns:priority>%@</tns:priority>"
                                         "<tns:description>%@</tns:description>"
                                         "<tns:dueDate>%@</tns:dueDate>"
                                         "<tns:listId>%@</tns:listId>"
                                         "<tns:assignId>%@</tns:assignId>"
                                         "</tns:soapIn>"
                                         "</tns:createTaskSoapInPart>"
                                         "</SOAP-ENV:Body>"
                                         "</SOAP-ENV:Envelope>",AccessToken,ACK,priority,desc,duedate,listid,assignid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_PostTaskWR{
	return App_URL;
}
+(NSString*)getSA_PostTaskWR{
	return App_URL;
}
+(NSString*)getSM_PostTaskWR:(NSString*)AccessToken Ack:(NSString*)ACK Priority:(NSString*)priority Description:(NSString*)desc dueDate:(NSString*)duedate listId:(NSString*)listid startDay:(NSString*)startday isEveryDay:(NSString*)iseveryday beforeDuedateTime1:(NSString*)beforeduedatetime1 beforeDuedateTime2:(NSString*)beforeduedatetime2 beforeDuedateTime3:(NSString*)beforeduedatetime3 onDuedateTime1:(NSString*)onduedatetime1 onDuedateTime2:(NSString*)onduedatetime2 onDuedateTime3:(NSString*)onduedatetime3 beforeDuedateChannelId:(NSString*)beforeduedatechannelid onDuedateChannelId:(NSString*)onduedatechannelid assignId:(NSString*)assignid{
	
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
                                         "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
                                         "<SOAP-ENV:Body>"
                                         "<tns:createTaskSoapInPart xmlns:tns=\"http://tempuri.org/\">"
                                         "<tns:credential>"
                                         "<tns:accesToken>%@</tns:accesToken>"
                                         "<tns:ACK>%@</tns:ACK>"
                                         "</tns:credential>"
                                         "<tns:soapIn>"
                                         "<tns:priority>%@</tns:priority>"
                                         "<tns:description>%@</tns:description>"
                                         "<tns:dueDate>%@</tns:dueDate>"
                                         "<tns:listId>%@</tns:listId>"
                                         "<tns:reminder>"
                                         "<tns:startDay>%@</tns:startDay>"
                                         "<tns:isEveryDay>%@</tns:isEveryDay>"
                                         "<tns:beforeDuedateTime1>%@</tns:beforeDuedateTime1>"
                                         "<tns:beforeDuedateTime2>%@</tns:beforeDuedateTime2>"
                                         "<tns:beforeDuedateTime3>%@</tns:beforeDuedateTime3>"
                                         "<tns:onDuedateTime1>%@</tns:onDuedateTime1>"
                                         "<tns:onDuedateTime2>%@</tns:onDuedateTime2>"
                                         "<tns:onDuedateTime3>%@</tns:onDuedateTime3>"
                                         "<tns:beforeDuedateChannelId>%@</tns:beforeDuedateChannelId>"
                                         "<tns:onDuedateChannelId>%@</tns:onDuedateChannelId>"
                                         "</tns:reminder>"
                                         "<tns:assignId>%@</tns:assignId>"
                                         "</tns:soapIn>"
                                         "</tns:createTaskSoapInPart>"
                                         "</SOAP-ENV:Body>"
                                         "</SOAP-ENV:Envelope>",AccessToken,ACK,priority,desc,duedate,listid,startday,iseveryday,beforeduedatetime1,beforeduedatetime2,beforeduedatetime3,onduedatetime1,onduedatetime2,onduedatetime3,beforeduedatechannelid,onduedatechannelid,assignid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_PostUpdateTask
{
	return App_URL;
}
+(NSString*)getSA_PostUpdateTask
{
	return App_URL;
}
+(NSString*)getSM_PostUpdateTask:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskId Priority:(NSString*)priority Description:(NSString*)desc dueDate:(NSString*)duedate listId:(NSString*)listid assignId:(NSString*)assignid reminderId:(NSString*)reminderid
{
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:updateTaskSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:listId>%@</tem:listId>"
                                         "<tem:description>%@</tem:description>"
                                         "<tem:priority>%@</tem:priority>"
                                         "<tem:dueDate>%@</tem:dueDate>"
                                         "<tem:assignedId>%@</tem:assignedId>"
                                         "<tem:reminderId>%@</tem:reminderId>"
                                         "</tem:soapIn>"
                                         "</tem:updateTaskSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskId,listid,desc,priority,duedate,assignid,reminderid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------


+(NSString*)getWS_DeleteTask
{
	return App_URL;
}
+(NSString*)getSA_DeleteTask
{
	return App_URL;
}
+(NSString*)getSM_DeleteTask:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskId
{
	NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
										 "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
										 "<SOAP-ENV:Body>"
										 "<tns:deleteTaskSoapInPart xmlns:tns=\"http://tempuri.org/\">"
										 "<tns:credential>"
										 "<tns:accesToken>%@</tns:accesToken>"
										 "<tns:ACK>%@</tns:ACK>"
										 "</tns:credential>"
										 "<tns:soapIn>"
										 "<tns:taskId>%@</tns:taskId>"
										 "</tns:soapIn>"
										 "</tns:deleteTaskSoapInPart>"
										 "</SOAP-ENV:Body>"
										 "</SOAP-ENV:Envelope>",AccessToken,ACK,taskId];
	return mStrdownloadSoapMessage;
}

#pragma mark - Reminder WS
//---------------------------------------------------------------------------------------


+(NSString*)getWS_CreateReminder
{
	return App_URL;
}
+(NSString*)getSA_CreateReminder
{
	return App_URL;
}
+(NSString*)getSM_CreateReminder:(NSString*)AccessToken Ack:(NSString*)ACK startDay:(NSString*)startday isEveryDay:(NSString*)iseveryday beforeDuedateTime1:(NSString*)beforeduedatetime1 beforeDuedateTime2:(NSString*)beforeduedatetime2 beforeDuedateTime3:(NSString*)beforeduedatetime3 onDuedateTime1:(NSString*)onduedatetime1 onDuedateTime2:(NSString*)onduedatetime2 onDuedateTime3:(NSString*)onduedatetime3 beforeDuedateChannelId:(NSString*)beforeduedatechannelid onDuedateChannelId:(NSString*)onduedatechannelid taskId:(NSString*)taskid
    {
        NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                             "<soapenv:Header/>"
                                             "<soapenv:Body>"
                                             "<tem:createReminderSoapInPart>"
                                             "<tem:credential>"
                                             "<tem:accesToken>%@</tem:accesToken>"
                                             "<tem:ACK>%@</tem:ACK>"
                                             "</tem:credential>"
                                             "<tem:soapIn>"
                                             "<tem:reminder>"
                                             "<tem:startDay>%@</tem:startDay>"
                                             "<tem:isEveryDay>%@</tem:isEveryDay>"
                                             "<tem:beforeDuedateTime1>%@</tem:beforeDuedateTime1>"
                                             "<tem:beforeDuedateTime2>%@</tem:beforeDuedateTime2>"
                                             "<tem:beforeDuedateTime3>%@</tem:beforeDuedateTime3>"
                                             "<tem:onDuedateTime1>%@</tem:onDuedateTime1>"
                                             "<tem:onDuedateTime2>%@</tem:onDuedateTime2>"
                                             "<tem:onDuedateTime3>%@</tem:onDuedateTime3>"
                                             "<tem:beforeDuedateChannelId>%@</tem:beforeDuedateChannelId>"
                                             "<tem:onDuedateChannelId>%@</tem:onDuedateChannelId>"
                                             "</tem:reminder>"
                                             "<tem:taskId>%@</tem:taskId>"
                                             "</tem:soapIn>"
                                             "</tem:createReminderSoapInPart>"
                                             "</soapenv:Body>"
                                            " </soapenv:Envelope>",AccessToken,ACK,startday,iseveryday,beforeduedatetime1,beforeduedatetime2,beforeduedatetime3,onduedatetime1,onduedatetime2,onduedatetime3,beforeduedatechannelid,onduedatechannelid,taskid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_UpdateReminder
{
	return App_URL;
}
+(NSString*)getSA_UpdateReminder
{
	return App_URL;
}
+(NSString*)getSM_UpdateReminder:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid startDay:(NSString*)startday isEveryDay:(NSString*)iseveryday beforeDuedateTime1:(NSString*)beforeduedatetime1 beforeDuedateTime2:(NSString*)beforeduedatetime2 beforeDuedateTime3:(NSString*)beforeduedatetime3 onDuedateTime1:(NSString*)onduedatetime1 onDuedateTime2:(NSString*)onduedatetime2 onDuedateTime3:(NSString*)onduedatetime3 beforeDuedateChannelId:(NSString*)beforeduedatechannelid onDuedateChannelId:(NSString*)onduedatechannelid reminderId:(NSString*)reminderid
    {
        NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
                                             "<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:wsdl=\"http://schemas.xmlsoap.org/wsdl/\" xmlns:soap=\"http://schemas.xmlsoap.org/wsdl/soap/\" xmlns:http=\"http://schemas.xmlsoap.org/wsdl/http/\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" xmlns:soapenc=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:mime=\"http://schemas.xmlsoap.org/wsdl/mime/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://tempuri.org/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" >"
                                             "<SOAP-ENV:Body>"
                                             "<tns:updateTaskReminderSoapInPart xmlns:tns=\"http://tempuri.org/\">"
                                             "<tns:credential>"
                                             "<tns:accesToken>%@</tns:accesToken>"
                                             "<tns:ACK>%@</tns:ACK>"
                                             "</tns:credential>"
                                             "<tns:soapIn>"
                                             "<tns:taskId>%@</tns:taskId>"
                                             "<tns:reminder>"
                                             "<tns:startDay>%@</tns:startDay>"
                                             "<tns:isEveryDay>%@</tns:isEveryDay>"
                                             "<tns:beforeDuedateTime1>%@</tns:beforeDuedateTime1>"
                                             "<tns:beforeDuedateTime2>%@</tns:beforeDuedateTime2>"
                                             "<tns:beforeDuedateTime3>%@</tns:beforeDuedateTime3>"
                                             "<tns:onDuedateTime1>%@</tns:onDuedateTime1>"
                                             "<tns:onDuedateTime2>%@</tns:onDuedateTime2>"
                                             "<tns:onDuedateTime3>%@</tns:onDuedateTime3>"
                                             "<tns:beforeDuedateChannelId>%@</tns:beforeDuedateChannelId>"
                                             "<tns:onDuedateChannelId>%@</tns:onDuedateChannelId>"
                                             "<tns:reminderId>%@</tns:reminderId>"
                                             "</tns:reminder>"
                                             "</tns:soapIn>"
                                             "</tns:updateTaskReminderSoapInPart>"
                                             "</SOAP-ENV:Body>"
                                             "</SOAP-ENV:Envelope>",AccessToken,ACK,taskid,startday,iseveryday,beforeduedatetime1,beforeduedatetime2,beforeduedatetime3,onduedatetime1,onduedatetime2,onduedatetime3,beforeduedatechannelid,onduedatechannelid,reminderid];
	return mStrdownloadSoapMessage;
}

//---------------------------------------------------------------------------------------

+(NSString*)getWS_DeleteReminder
{
	return App_URL;
}
+(NSString*)getSA_DeleteReminder
{
	return App_URL;
}
+(NSString*)getSM_DeleteReminder:(NSString*)AccessToken Ack:(NSString*)ACK taskId:(NSString*)taskid reminderId:(NSString*)reminderid
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:deleteReminderSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:reminderId>%@</tem:reminderId>"
                                         "</tem:soapIn>"
                                         "</tem:deleteReminderSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,reminderid];
	return mStrdownloadSoapMessage;
}

#pragma mark - CallTaskBack.
//---------------------------------------------------------------------------------------

+(NSString*)getWS_CallBackTask
{
	return App_URL;
}
+(NSString*)getSA_CallBackTask
{
	return App_URL;
}
+(NSString*)getSM_CallBackTask:(NSString *)AccessToken Ack:(NSString *)ACK taskId:(NSString *)taskid UserId:(NSString *)userid
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                        "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:callBackTaskSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:userId>%@</tem:userId>"
                                         "</tem:soapIn>"
                                         "</tem:callBackTaskSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,userid];
	return mStrdownloadSoapMessage;
}

#pragma mark - GiveTaskBack.
//---------------------------------------------------------------------------------------

+(NSString*)getWS_GiveBackTask
{
	return App_URL;
}
+(NSString*)getSA_GiveBackTask
{
	return App_URL;
}
+(NSString*)getSM_GiveBackTask:(NSString *)AccessToken Ack:(NSString *)ACK taskId:(NSString *)taskid UserId:(NSString *)userid
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:giveBackTaskSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:userId>%@</tem:userId>"
                                         "</tem:soapIn>"
                                         "</tem:giveBackTaskSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,userid];
	return mStrdownloadSoapMessage;
}

#pragma mark- AssignToOwnContact.

//---------------------------------------------------------------------------------------

+(NSString*)getWS_AssignToOwnContact
{
	return App_URL;
}
+(NSString*)getSA_AssignToOwnContact
{
	return App_URL;
}
+(NSString*)getSM_AssignToOwnContact:(NSString *)AccessToken Ack:(NSString *)ACK taskId:(NSString *)taskid contactId:(NSString *)contactid
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:assignTaskToOwnContactSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:contactId>%@</tem:contactId>"
                                         "</tem:soapIn>"
                                         "</tem:assignTaskToOwnContactSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,contactid];
	return mStrdownloadSoapMessage;
}

#pragma mark- AssignToOrgContact.

//---------------------------------------------------------------------------------------

+(NSString*)getWS_AssignToOrgContact
{
	return App_URL;
}
+(NSString*)getSA_AssignToOrgContact
{
	return App_URL;
}
+(NSString*)getSM_AssignToOrgContact:(NSString *)AccessToken Ack:(NSString *)ACK taskId:(NSString *)taskid contactId:(NSString *)contactid
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:assignTaskToOrgContactSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:contactId>%@</tem:contactId>"
                                         "</tem:soapIn>"
                                         "</tem:assignTaskToOrgContactSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,contactid];
	return mStrdownloadSoapMessage;
}

#pragma mark - updateTaskPrioritySoapInPart

//---------------------------------------------------------------------------------------

+(NSString*)getWS_UpdateTaskPriority
{
	return App_URL;
}
+(NSString*)getSA_UpdateTaskPriority
{
	return App_URL;
}
+(NSString*)getSM_UpdateTaskPriority:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskid TaskPriority:(NSString*)taskpriority
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:updateTaskPrioritySoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:taskPriority>%@</tem:taskPriority>"
                                         "</tem:soapIn>"
                                         "</tem:updateTaskPrioritySoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,taskpriority];
	return mStrdownloadSoapMessage;
}

#pragma mark - Update TaskFadeOnDate.

//---------------------------------------------------------------------------------------

+(NSString*)getWS_UpdateTaskFadeOnDate
{
	return App_URL;
}
+(NSString*)getSA_UpdateTaskFadeOnDate
{
	return App_URL;
}
+(NSString*)getSM_UpdateTaskFadeOnDate:(NSString*)AccessToken Ack:(NSString*)ACK TaskId:(NSString*)taskid TaskFadeOnDate:(NSString*)taskfadeondate
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:updateTaskFadeOnDateSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:taskFadeOnDate>%@</tem:taskFadeOnDate>"
                                         "</tem:soapIn>"
                                         "</tem:updateTaskFadeOnDateSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,taskfadeondate];
	return mStrdownloadSoapMessage;
}

#pragma mark - Update User Setting.

//---------------------------------------------------------------------------------------

+(NSString*)getWS_UpdateUserSetting
{
	return App_URL;
}
+(NSString*)getSA_UpdateUserSetting
{
	return App_URL;
}
+(NSString*)getSM_UpdateUserSetting:(NSString*)AccessToken Ack:(NSString*)ACK TimeFormat:(NSString*)timeformat DateFormat:(NSString*)dateformat TimeZone:(NSString*)timezone Language:(NSString*)language
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:updateSettingsSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:timeFormat>%@</tem:timeFormat>"
                                         "<tem:dateFormat>%@</tem:dateFormat>"
                                         "<tem:timeZone>%@</tem:timeZone>"
                                         "<tem:language>%@</tem:language>"
                                         "</tem:soapIn>"
                                         "</tem:updateSettingsSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,timeformat,dateformat,timezone,language];
	return mStrdownloadSoapMessage;
}

#pragma mark - Create Message.

//---------------------------------------------------------------------------------------

+(NSString*)getWS_CreateMsg
{
	return App_URL;
}
+(NSString*)getSA_CreateMsg
{
	return App_URL;
}
+(NSString*)getSM_CreateMsg:(NSString*)AccessToken Ack:(NSString*)ACK MsgId:(NSString*)msgid MsgDesc:(NSString*)msgdesc MsgType:(NSString*)msgtype RecieverId:(NSString*)recieverid SenderId:(NSString*)senderid TaskId:(NSString*)taskid
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:createMessageSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:messageId>%@</tem:messageId>"
                                         "<tem:messageDescription>%@</tem:messageDescription>"
                                         "<tem:messageType>%@</tem:messageType>"
                                         "<tem:receiverId>%@</tem:receiverId>"
                                         "<tem:senderId>%@</tem:senderId>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "</tem:soapIn>"
                                         "</tem:createMessageSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,msgid,msgdesc,msgtype,recieverid,senderid,taskid];
	return mStrdownloadSoapMessage;
}

#pragma mark - Archive Task.

//---------------------------------------------------------------------------------------

+(NSString*)getWS_ArchiveTask
{
	return App_URL;
}
+(NSString*)getSA_ArchiveTask
{
	return App_URL;
}
+(NSString*)getSM_ArchiveTask:(NSString *)AccessToken Ack:(NSString *)ACK TaskId:(NSString *)taskid UserId:(NSString *)userid
{
    NSString *mStrdownloadSoapMessage = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">"
                                         "<soapenv:Header/>"
                                         "<soapenv:Body>"
                                         "<tem:archiveTaskSoapInPart>"
                                         "<tem:credential>"
                                         "<tem:accesToken>%@</tem:accesToken>"
                                         "<tem:ACK>%@</tem:ACK>"
                                         "</tem:credential>"
                                         "<tem:soapIn>"
                                         "<tem:taskId>%@</tem:taskId>"
                                         "<tem:userId>%@</tem:userId>"
                                         "</tem:soapIn>"
                                         "</tem:archiveTaskSoapInPart>"
                                         "</soapenv:Body>"
                                         "</soapenv:Envelope>",AccessToken,ACK,taskid,userid];
	return mStrdownloadSoapMessage;
}
//---------------------------------------------------------------------------------------

@end
