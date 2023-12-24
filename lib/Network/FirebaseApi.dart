import 'dart:convert';
import 'dart:developer';
//import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'package:http/http.dart' as http;

import '../core/EncryptDecrypt.dart';


class ApiRepository{

  // static const BREVO_API_KEY = "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";
 // static const BREVO_API_KEY = "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";
  //static const BREVO_API_KEY = "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";
  static const BREVO_API_KEY = "xsmtpsib-992d10ec15416056613c3973c717155b0a4f8a98c636790ee407dcb8c0b29f92-TkhGWKZxO6Bna2Sv";
  //static const BREVO_API_KEY = "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";
  // static const BREVO_API_KEY = "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";
  static const BREVO_BASE_URL = "https://api.brevo.com/v3";



  //Flutter get all the Thrivers



  //Get Solutions
  //Get
  Future<void> createThriver(Map<String, dynamic> thriversData) async {
    try {
      // Replace 'your_collection' with your actual collection name
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('Thrivers');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Thrivers').get();
      int documentCount = querySnapshot.docs.length+1;



      // Add the document to the collection
      await collectionReference.doc("TH$documentCount").set(thriversData);

    } catch (e) {
      print('Error creating document: $e');
    }
  }

  static Future<String?> uploadBytesAndGetDownloadUrl(String destination, Uint8List data) async {
    try {
      String downloadUrl = "";
      final ref = FirebaseStorage.instance.ref(destination+".jpg");
      await ref.putData(data).whenComplete(() async {
        downloadUrl = await ref.getDownloadURL();
      });
      return downloadUrl;
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<String> LoginAdminPanel(String userName, String password) async {

    String loginResponse = "Something went wrong!";

    print("Getting Admin Details Content");

    late DocumentSnapshot documentSnapshot;

    await FirebaseFirestore.instance
        .collection('/AdminDetails').limit(1)
        .get()
        .then((QuerySnapshot docSnapshot) {

      documentSnapshot =docSnapshot.docs.first;
      print("documentSnapshot.data()");
      print(documentSnapshot.data());
    });


    if((documentSnapshot.get("adminusername")??"")==userName){
      if((documentSnapshot.get("adminpassword")??"")==password){
        loginResponse =  "Success";
      }
    }

    return loginResponse;

  }

  Future<void> UpdateSectionPreset(DocumentReference<Object?> documentReference,Map<String, dynamic> data) async{
    await documentReference.update(data);
  }

  Future<void> DeleteEvent(DocumentReference<Object?> documentReference) async {
    print("Deletiong event");
    print(documentReference.id);
    await documentReference.delete();
  }

  /*Future<void> CreateEvent(Map<String, dynamic> data) async {

    await FirebaseFirestore.instance.collection('Events').doc().set(data);
  }*/




  Future<void> sendInvitationMails(List<String> listOfRecieversEmails, String eventName,String eventImageUrl,String eventDescription,String ticketDescription,String ticketReferenceNumber,String openAppLink,) async {

    List<Map> recievers = [];

    listOfRecieversEmails.forEach((email) {
      recievers.add({
        "email":email,
        "name":email.split("@")[0].split('.')[0]
      });
    });


    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'api-key': BREVO_API_KEY
    };

    var request = http.Request('POST', Uri.parse('$BREVO_BASE_URL/smtp/email'));
    request.body = json.encode({
      "sender": {
        "name": "Retail Hub",
        "email": "admin@retialhub.com"
      },
      "to": recievers,
      "subject": "Invitation to $eventName",
      "htmlContent": "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"format-detection\" content=\"telephone=no\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title></title><style type=\"text/css\" emogrify=\"no\">#outlook a { padding:0; } .ExternalClass { width:100%; } .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div { line-height: 100%; } table td { border-collapse: collapse; mso-line-height-rule: exactly; } .editable.image { font-size: 0 !important; line-height: 0 !important; } .nl2go_preheader { display: none !important; mso-hide:all !important; mso-line-height-rule: exactly; visibility: hidden !important; line-height: 0px !important; font-size: 0px !important; } body { width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0; } img { outline:none; text-decoration:none; -ms-interpolation-mode: bicubic; } a img { border:none; } table { border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; } th { font-weight: normal; text-align: left; } *[class=\"gmail-fix\"] { display: none !important; } </style><style type=\"text/css\" emogrify=\"no\"> @media (max-width: 600px) { .gmx-killpill { content: \' \03D1\';} } </style><style type=\"text/css\" emogrify=\"no\">@media (max-width: 600px) { .gmx-killpill { content: \' \03D1\';} .r0-o { border-style: solid !important; margin: 0 auto 0 auto !important; width: 320px !important } .r1-i { background-color: #000000 !important } .r2-c { box-sizing: border-box !important; text-align: center !important; valign: top !important; width: 100% !important } .r3-o { border-style: solid !important; margin: 0 auto 0 auto !important; width: 100% !important } .r4-i { background-color: #000000 !important; padding-bottom: 20px !important; padding-left: 15px !important; padding-right: 15px !important; padding-top: 20px !important } .r5-c { box-sizing: border-box !important; display: block !important; valign: top !important; width: 100% !important } .r6-o { border-style: solid !important; width: 100% !important } .r7-i { padding-left: 0px !important; padding-right: 0px !important } .r8-i { padding-bottom: 15px !important; padding-top: 15px !important } .r9-c { box-sizing: border-box !important; text-align: left !important; valign: top !important; width: 100% !important } .r10-o { border-style: solid !important; margin: 0 auto 0 0 !important; width: 100% !important } .r11-i { padding-top: 15px !important; text-align: center !important } .r12-i { padding-bottom: 15px !important; padding-top: 15px !important; text-align: center !important } .r13-i { padding-bottom: 0px !important; padding-left: 10px !important; padding-right: 10px !important; padding-top: 0px !important } .r14-i { padding-top: 15px !important; text-align: left !important } .r15-i { padding-bottom: 0px !important; padding-left: 0px !important; padding-right: 0px !important; padding-top: 0px !important; text-align: left !important } .r16-c { box-sizing: border-box !important; padding: 0 !important; text-align: center !important; valign: top !important; width: 100% !important } .r17-o { border-style: solid !important; margin: 0 auto 0 auto !important; margin-bottom: 15px !important; margin-top: 15px !important; width: 100% !important } .r18-i { padding: 0 !important; text-align: center !important } .r19-r { background-color: #bee73e !important; border-radius: 4px !important; border-width: 0px !important; box-sizing: border-box; height: initial !important; padding: 0 !important; padding-bottom: 12px !important; padding-left: 5px !important; padding-right: 5px !important; padding-top: 12px !important; text-align: center !important; width: 100% !important } body { -webkit-text-size-adjust: none } .nl2go-responsive-hide { display: none } .nl2go-body-table { min-width: unset !important } .mobshow { height: auto !important; overflow: visible !important; max-height: unset !important; visibility: visible !important; border: none !important } .resp-table { display: inline-table !important } .magic-resp { display: table-cell !important } } </style><!--[if !mso]><!--><style type=\"text/css\" emogrify=\"no\">@import url(\"https://fonts.googleapis.com/css2?family=Lucida sans unicode\"); </style><!--<![endif]--><style type=\"text/css\">p, h1, h2, h3, h4, ol, ul { margin: 0; } a, a:link { color: #de3daf; text-decoration: underline } .nl2go-default-textstyle { color: #3b3f44; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 18px; line-height: 1.5; word-break: break-word } .default-button { color: #ffffff; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 16px; font-style: normal; font-weight: bold; line-height: 1.15; text-decoration: none; word-break: break-word } .default-heading1 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 36px; word-break: break-word } .default-heading2 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 32px; word-break: break-word } .default-heading3 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 24px; word-break: break-word } .default-heading4 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 18px; word-break: break-word } a[x-apple-data-detectors] { color: inherit !important; text-decoration: inherit !important; font-size: inherit !important; font-family: inherit !important; font-weight: inherit !important; line-height: inherit !important; } .no-show-for-you { border: none; display: none; float: none; font-size: 0; height: 0; line-height: 0; max-height: 0; mso-hide: all; overflow: hidden; table-layout: fixed; visibility: hidden; width: 0; } </style><!--[if mso]><xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml><![endif]--><style type=\"text/css\">a:link{color: #de3daf; text-decoration: underline;}</style></head><body bgcolor=\"#000000\" text=\"#3b3f44\" link=\"#de3daf\" yahoo=\"fix\" style=\"background-color: #000000;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" class=\"nl2go-body-table\" width=\"100%\" style=\"background-color: #000000; width: 100%;\"><tr><td> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"600\" align=\"center\" class=\"r0-o\" style=\"table-layout: fixed; width: 600px;\"><tr><td valign=\"top\" class=\"r1-i\" style=\"background-color: #000000;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" align=\"center\" class=\"r3-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td class=\"r4-i\" style=\"background-color: #000000; padding-bottom: 20px; padding-top: 20px;\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><th width=\"100%\" valign=\"top\" class=\"r5-c\" style=\"font-weight: normal;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r6-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td valign=\"top\" class=\"r7-i\" style=\"padding-left: 15px; padding-right: 15px;\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><td class=\"r2-c\" align=\"center\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"570\" class=\"r3-o\" style=\"table-layout: fixed; width: 570px;\"><tr><td class=\"r8-i\" style=\"font-size: 0px; line-height: 0px; padding-bottom: 15px; padding-top: 15px;\"> <img src=\"https://img.mailinblue.com/4783268/images/content_library/original/64ba45dc10ce306c5d556aa7.png\" width=\"570\" border=\"0\" style=\"display: block; width: 100%;\"></td> </tr></table></td> </tr><tr><td class=\"r9-c\" align=\"left\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r10-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td align=\"center\" valign=\"top\" class=\"r11-i nl2go-default-textstyle\" style=\"color: #3b3f44; font-family: lucida sans unicode,lucida grande,sans-serif; font-size: 18px; word-break: break-word; line-height: 1.5; padding-top: 15px; text-align: center;\"> <div><h1 class=\"default-heading1\" style=\"margin: 0; color: #1f2d3d; font-family: verdana,geneva,sans-serif,Arial; font-size: 36px; word-break: break-word;\"><span style=\"color: #bee73e; font-family: Verdana; font-size: 36px;\">🎊Invitiation🎊</span></h1></div> </td> </tr></table></td> </tr><tr><td class=\"r9-c\" align=\"left\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r10-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td align=\"center\" valign=\"top\" class=\"r11-i nl2go-default-textstyle\" style=\"color: #3b3f44; font-family: lucida sans unicode,lucida grande,sans-serif; font-size: 18px; word-break: break-word; line-height: 1.5; padding-top: 15px; text-align: center;\"> <div><p style=\"margin: 0;\"><span style=\"color: #bee73e; font-family: Lucida sans unicode; font-size: 20px;\"><strong>You have been Invited to </strong></span><span style=\"color: #bee73e; font-family: Verdana; font-size: 24px;\"><strong>$eventName</strong></span><span style=\"font-family: Verdana; font-size: 24px;\"> </span></p></div> </td> </tr></table></td> </tr><tr><td class=\"r9-c\" align=\"left\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r10-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td align=\"center\" valign=\"top\" class=\"r12-i nl2go-default-textstyle\" style=\"color: #3b3f44; font-family: lucida sans unicode,lucida grande,sans-serif; font-size: 18px; line-height: 1.5; word-break: break-word; padding-bottom: 15px; padding-top: 15px; text-align: center;\"> <div><p style=\"margin: 0;\"><span style=\"color: #BEE73E;\">${eventDescription} . </p></div> </td> </tr></table></td> </tr></table></td> </tr></table></th> </tr></table></td> </tr></table><table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" align=\"center\" class=\"r3-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td class=\"r13-i\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><th width=\"100%\" valign=\"top\" class=\"r5-c\" style=\"font-weight: normal;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r6-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td valign=\"top\" class=\"r7-i\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><td class=\"r2-c\" align=\"center\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"600\" class=\"r3-o\" style=\"border-collapse: separate; border-radius: 0px; table-layout: fixed; width: 600px;\"><tr><td class=\"r8-i\" style=\"border-radius: 0px; font-size: 0px; line-height: 0px; padding-bottom: 15px; padding-top: 15px;\"> <img src=\"$eventImageUrl\" width=\"600\" border=\"0\" style=\"display: block; width: 100%; border-radius: 0px;\"></td> </tr></table></td> </tr><tr><td class=\"r9-c\" align=\"left\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r10-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td align=\"left\" valign=\"top\" class=\"r14-i nl2go-default-textstyle\" style=\"color: #3b3f44; font-family: lucida sans unicode,lucida grande,sans-serif; font-size: 18px; word-break: break-word; line-height: 1.5; padding-top: 15px; text-align: left;\"> <div><h3 class=\"default-heading3\" style=\"margin: 0; color: #1f2d3d; font-family: verdana,geneva,sans-serif,Arial; font-size: 24px; word-break: break-word;\"><span style=\"color: #bee73e; font-family: Verdana; font-size: 24px;\">Your Ticket Details</span></h3></div> </td> </tr></table></td> </tr><tr><td class=\"r9-c\" align=\"left\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r10-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td align=\"left\" valign=\"top\" class=\"r15-i nl2go-default-textstyle\" style=\"color: #3b3f44; font-family: lucida sans unicode,lucida grande,sans-serif; font-size: 18px; line-height: 1.5; word-break: break-word; text-align: left;\"> <div><p style=\"margin: 0;\"> </p><p style=\"margin: 0;\"><span style=\"color: #BEE73E;\"><strong>#$ticketReferenceNumber</strong></span><br><span style=\"color: #BEE73E;\">$ticketDescription</span><br> </p></div> </td> </tr></table></td> </tr><tr><td class=\"r16-c\" align=\"center\" style=\"align: center; padding-bottom: 15px; padding-top: 15px; valign: top;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"300\" class=\"r17-o\" style=\"background-color: #bee73e; border-collapse: separate; border-color: #bee73e; border-radius: 4px; border-style: solid; border-width: 0px; table-layout: fixed; width: 300px;\"><tr><td height=\"18\" align=\"center\" valign=\"top\" class=\"r18-i nl2go-default-textstyle\" style=\"word-break: break-word; background-color: #bee73e; border-radius: 4px; color: #ffffff; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 16px; font-style: normal; line-height: 1.15; padding-bottom: 12px; padding-left: 5px; padding-right: 5px; padding-top: 12px; text-align: center;\"> <a href=\"$openAppLink\" class=\"r19-r default-button\" target=\"_blank\" data-btn=\"1\" style=\"font-style: normal; font-weight: bold; line-height: 1.15; text-decoration: none; word-break: break-word; word-wrap: break-word; display: inline-block; -webkit-text-size-adjust: none; color: #ffffff; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 16px;\"> <span><span style=\"color: #000000;\">Open Retail Hub App</span></span></a> </td> </tr></table></td> </tr></table></td> </tr></table></th> </tr></table></td> </tr></table></td> </tr></table></td> </tr></table></body></html>\""
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print("Brevo Invitation SENT");
      print(await response.stream.bytesToString());
    }
    else {
      print("Brevo Invitation couldn't be send");
      print(response.reasonPhrase);
    }

  }



  Future<bool> passwordlessSignInWithEmail(String emailAddress) async {

    //Send Email to brevo here

    print("passwordlessSignInWithEmail");
    bool isSuccessFull = false;
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://dev.retailhub.cloud/api/v2/passwordless-login'));
    request.body = json.encode({
      "email": emailAddress
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());

      isSuccessFull = true;

    }
    else {
      print("response.reasonPhrase");
      print(response.reasonPhrase);
    }
    return isSuccessFull;
  }

  Future<bool> verifyTheLoginToken(String token) async {

    bool isEmailValidatedSuccessfully = false;
    print("verifyTheLoginToken");

    var request = http.Request('GET', Uri.parse('https://dev.retailhub.cloud/api/v2/account?token=$token'));
    request.body = '''''';

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      isEmailValidatedSuccessfully = true;

    }
    else {
      print("response.reasonPhrase");
      print(response.reasonPhrase);
    }
    return isEmailValidatedSuccessfully;
  }

  Future<bool> sendLoginMail(String email) async {

    bool isSuccessFull = false;

    List<Map> recievers = [];
    recievers.add({
      "email":email,
      "name":email.split("@")[0].split('.')[0]
    });

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'api-key': BREVO_API_KEY
    };

    String token = EncryptData.createJWT({"email":email});
    
    String loginlink = "https://thrivers-8aa27.web.app/authenticate?loginToken=$token";

    var request = http.Request('POST', Uri.parse('$BREVO_BASE_URL/smtp/email'));
    request.body = json.encode({
      "sender": {
        "name": "Thriver",
        "email": "admin@thriver.com"
      },
      "to": recievers,
      "subject": "Passwordless Login to your Thriver Account",
      "htmlContent": "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\<html xmlns=\"http://www.w3.org/1999/xhtml\" xmlns:v=\"urn:schemas-microsoft-com:vml\" xmlns:o=\"urn:schemas-microsoft-com:office:office\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"format-detection\" content=\"telephone=no\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title>Passwordless Login to your App</title><style type=\"text/css\" emogrify=\"no\">#outlook a { padding:0; } .ExternalClass { width:100%; } .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div { line-height: 100%; } table td { border-collapse: collapse; mso-line-height-rule: exactly; } .editable.image { font-size: 0 !important; line-height: 0 !important; } .nl2go_preheader { display: none !important; mso-hide:all !important; mso-line-height-rule: exactly; visibility: hidden !important; line-height: 0px !important; font-size: 0px !important; } body { width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0; } img { outline:none; text-decoration:none; -ms-interpolation-mode: bicubic; } a img { border:none; } table { border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; } th { font-weight: normal; text-align: left; } *[class=\"gmail-fix\"] { display: none !important; } </style><style type=\"text/css\" emogrify=\"no\"> @media (max-width: 600px) { .gmx-killpill { content: \' \03D1\';} } </style><style type=\"text/css\" emogrify=\"no\">@media (max-width: 600px) { .gmx-killpill { content: \' \03D1\';} .r0-o { border-style: solid !important; margin: 0 auto 0 auto !important; width: 320px !important } .r1-i { background-color: #000000 !important } .r2-c { box-sizing: border-box !important; text-align: center !important; valign: top !important; width: 100% !important } .r3-o { border-style: solid !important; margin: 0 auto 0 auto !important; width: 100% !important } .r4-i { background-color: #000000 !important; padding-bottom: 20px !important; padding-left: 15px !important; padding-right: 15px !important; padding-top: 20px !important } .r5-c { box-sizing: border-box !important; display: block !important; valign: top !important; width: 100% !important } .r6-o { border-style: solid !important; width: 100% !important } .r7-i { padding-left: 0px !important; padding-right: 0px !important } .r8-o { border-style: solid !important; margin: 0 auto 0 auto !important; margin-bottom: 0px !important; margin-top: 0px !important; width: 100% !important } .r9-i { padding-bottom: 15px !important; padding-top: 15px !important } .r10-c { box-sizing: border-box !important; text-align: left !important; valign: top !important; width: 100% !important } .r11-o { border-style: solid !important; margin: 0 auto 0 0 !important; margin-bottom: 0px !important; margin-top: 0px !important; width: 100% !important } .r12-i { padding-bottom: 0px !important; padding-left: 0px !important; padding-right: 0px !important; padding-top: 0px !important; text-align: center !important } .r13-i { padding-bottom: 0px !important; padding-left: 10px !important; padding-right: 10px !important; padding-top: 0px !important } .r14-o { border-style: solid !important; margin: 0 auto 0 0 !important; width: 100% !important } .r15-i { padding-top: 15px !important; text-align: center !important } .r16-c { box-sizing: border-box !important; padding: 0 !important; text-align: center !important; valign: top !important; width: 100% !important } .r17-o { border-style: solid !important; margin: 0 auto 0 auto !important; margin-bottom: 15px !important; margin-top: 15px !important; width: 100% !important } .r18-i { padding: 0 !important; text-align: center !important } .r19-r { background-color: #bee73e !important; border-radius: 4px !important; border-width: 0px !important; box-sizing: border-box; height: initial !important; padding: 0 !important; padding-bottom: 12px !important; padding-left: 5px !important; padding-right: 5px !important; padding-top: 12px !important; text-align: center !important; width: 100% !important } body { -webkit-text-size-adjust: none } .nl2go-responsive-hide { display: none } .nl2go-body-table { min-width: unset !important } .mobshow { height: auto !important; overflow: visible !important; max-height: unset !important; visibility: visible !important; border: none !important } .resp-table { display: inline-table !important } .magic-resp { display: table-cell !important } } </style><!--[if !mso]><!--><style type=\"text/css\" emogrify=\"no\">@import url(\"https://fonts.googleapis.com/css2?family=Lucida sans unicode\"); </style><!--<![endif]--><style type=\"text/css\">p, h1, h2, h3, h4, ol, ul { margin: 0; } a, a:link { color: #de3daf; text-decoration: underline } .nl2go-default-textstyle { color: #3b3f44; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 18px; line-height: 1.5; word-break: break-word } .default-button { color: #ffffff; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 16px; font-style: normal; font-weight: bold; line-height: 1.15; text-decoration: none; word-break: break-word } .default-heading1 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 36px; word-break: break-word } .default-heading2 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 32px; word-break: break-word } .default-heading3 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 24px; word-break: break-word } .default-heading4 { color: #1F2D3D; font-family: verdana, geneva, sans-serif, Arial; font-size: 18px; word-break: break-word } a[x-apple-data-detectors] { color: inherit !important; text-decoration: inherit !important; font-size: inherit !important; font-family: inherit !important; font-weight: inherit !important; line-height: inherit !important; } .no-show-for-you { border: none; display: none; float: none; font-size: 0; height: 0; line-height: 0; max-height: 0; mso-hide: all; overflow: hidden; table-layout: fixed; visibility: hidden; width: 0; } </style><!--[if mso]><xml> <o:OfficeDocumentSettings> <o:AllowPNG/> <o:PixelsPerInch>96</o:PixelsPerInch> </o:OfficeDocumentSettings> </xml><![endif]--><style type=\"text/css\">a:link{color: #de3daf; text-decoration: underline;}</style></head><body bgcolor=\"#000000\" text=\"#3b3f44\" link=\"#de3daf\" yahoo=\"fix\" style=\"background-color: #000000;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" class=\"nl2go-body-table\" width=\"100%\" style=\"background-color: #000000; width: 100%;\"><tr><td> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"600\" align=\"center\" class=\"r0-o\" style=\"table-layout: fixed; width: 600px;\"><tr><td valign=\"top\" class=\"r1-i\" style=\"background-color: #000000;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" align=\"center\" class=\"r3-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td class=\"r4-i\" style=\"background-color: #000000; padding-bottom: 20px; padding-top: 20px;\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><th width=\"100%\" valign=\"top\" class=\"r5-c\" style=\"font-weight: normal;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r6-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td valign=\"top\" class=\"r7-i\" style=\"padding-left: 15px; padding-right: 15px;\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><td class=\"r2-c\" align=\"center\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"570\" class=\"r8-o\" style=\"table-layout: fixed; width: 570px;\"><tr><td class=\"r9-i\" style=\"font-size: 0px; line-height: 0px; padding-bottom: 15px; padding-top: 15px;\"> <img src=\"https://img.mailinblue.com/4783268/images/content_library/original/64ba45dc10ce306c5d556aa7.png\" width=\"570\" border=\"0\" style=\"display: block; width: 100%;\"></td> </tr></table></td> </tr><tr><td class=\"r10-c\" align=\"left\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r11-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td align=\"center\" valign=\"top\" class=\"r12-i nl2go-default-textstyle\" style=\"color: #3b3f44; font-family: lucida sans unicode,lucida grande,sans-serif; font-size: 18px; word-break: break-word; line-height: 1.5; text-align: center;\"> <div><h1 class=\"default-heading1\" style=\"margin: 0; color: #1f2d3d; font-family: verdana,geneva,sans-serif,Arial; font-size: 36px; word-break: break-word;\"><span style=\"color: #bee73e; font-family: Verdana; font-size: 36px;\">Login to your App?</span></h1></div> </td> </tr></table></td> </tr></table></td> </tr></table></th> </tr></table></td> </tr></table><table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" align=\"center\" class=\"r3-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td class=\"r13-i\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><th width=\"100%\" valign=\"top\" class=\"r5-c\" style=\"font-weight: normal;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r6-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td valign=\"top\" class=\"r7-i\"> <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\"><tr><td class=\"r2-c\" align=\"center\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"180\" class=\"r3-o\" style=\"table-layout: fixed; width: 180px;\"><tr><td class=\"r9-i\" style=\"font-size: 0px; line-height: 0px; padding-bottom: 15px; padding-top: 15px;\"> <img src=\"https://img.mailinblue.com/4783268/images/content_library/original/65423b2585175d093f1f9319.png\" width=\"180\" border=\"0\" style=\"display: block; width: 100%;\"></td> </tr></table></td> </tr><tr><td class=\"r10-c\" align=\"left\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"100%\" class=\"r14-o\" style=\"table-layout: fixed; width: 100%;\"><tr><td align=\"center\" valign=\"top\" class=\"r15-i nl2go-default-textstyle\" style=\"color: #3b3f44; font-family: lucida sans unicode,lucida grande,sans-serif; font-size: 18px; word-break: break-word; line-height: 1.5; padding-top: 15px; text-align: center;\"> <div><h3 class=\"default-heading3\" style=\"margin: 0; color: #1f2d3d; font-family: verdana,geneva,sans-serif,Arial; font-size: 24px; word-break: break-word;\"><span style=\"color: #bee73e; font-family: Verdana; font-size: 24px;\">Passwordless login to your dashboard</span></h3></div> </td> </tr></table></td> </tr><tr><td class=\"r16-c\" align=\"center\" style=\"align: center; padding-bottom: 15px; padding-top: 15px; valign: top;\"> <table cellspacing=\"0\" cellpadding=\"0\" border=\"0\" role=\"presentation\" width=\"300\" class=\"r17-o\" style=\"background-color: #bee73e; border-collapse: separate; border-color: #bee73e; border-radius: 4px; border-style: solid; border-width: 0px; table-layout: fixed; width: 300px;\"><tr><td height=\"18\" align=\"center\" valign=\"top\" class=\"r18-i nl2go-default-textstyle\" style=\"word-break: break-word; background-color: #bee73e; border-radius: 4px; color: #ffffff; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 16px; font-style: normal; line-height: 1.15; padding-bottom: 12px; padding-left: 5px; padding-right: 5px; padding-top: 12px; text-align: center;\"> <a href=\"$loginlink\" class=\"r19-r default-button\" target=\"_blank\" title=\"Retail hub App\" data-btn=\"1\" style=\"font-style: normal; font-weight: bold; line-height: 1.15; text-decoration: none; word-break: break-word; word-wrap: break-word; display: block; -webkit-text-size-adjust: none; color: #ffffff; font-family: lucida sans unicode, lucida grande, sans-serif; font-size: 16px;\"> <span><span style=\"color: #000000;\">Login</span></span></a> </td> </tr></table></td> </tr></table></td> </tr></table></th> </tr></table></td> </tr></table></td> </tr></table></td> </tr></table></body></html>\"",


    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Brevo login SENT");
      isSuccessFull = true;
      print(await response.stream.bytesToString());
    }
    else {
      print("Brevo Login couldn't be send");
      print(response);
      print(response.statusCode);
      print(response.reasonPhrase);
    }
    return isSuccessFull;
  }

  Future<void> DeleteSectionPreset(DocumentReference<Object?> documentReference) async {
    await documentReference.delete();
  }


  //Check if user exists else show regsitration UI

}
