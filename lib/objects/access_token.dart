class Token {
	final String access_token;

Token({this.access_token
});


factory Token.fromJson(Map<String, String> json){
  return Token(
access_token : json['access_token']
  );
}
}