import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petcare/src/services/account_service.dart';
import 'package:petcare/src/storage/storage.dart';

class UserService {
  
  final String _firebaseKey = 'AIzaSyD1eKlsC0497JR4rmkj7n0MoLyMYEKCV4I';
  final _storage = new Storage();
  final accountService = new AccountService();

  Future<Map<String, dynamic>> login( String email, String password ) async {
    /* final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print( decodedResp );

    if ( decodedResp.containsKey('idToken') ) {
      //TODO: Salvar el token en el storage
      _storage.token = decodedResp['idToken'];

      return { 'ok':true, 'token': decodedResp['idToken'] };
    } else {
      return { 'ok':false, 'mensaje': decodedResp['error']['message'] };
    } */
    
    
  }

  Future<Map<String, dynamic>> registerUser( String email, String password ) async {
    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print( decodedResp );

    if ( decodedResp.containsKey('idToken') ) {
      //TODO: Salvar el token en el storage
      _storage.token = decodedResp['idToken'];


      return { 'ok':true, 'token': decodedResp['idToken'] };
    } else {
      return { 'ok':false, 'mensaje': decodedResp['error']['message'] };
    }
  }
}