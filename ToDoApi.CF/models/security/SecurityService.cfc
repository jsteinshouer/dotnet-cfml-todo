
/* 
 * Security service
 */
component singleton {

	property name="wirebox" inject="wirebox";
	property name="httpHelper" inject="util.HTTPHelper";
	property name="bcrypt" inject="@BCrypt";

	/**
	 * Constructor
	 * 
	 * @jwtSecret.inject coldbox:setting:JWT_SECRET
	 * @jwtIssuer.inject coldbox:setting:JWT_ISSUER
	 * @jwtExpirationinMinutes.inject coldbox:setting:JWT_EXP_MIN
	 * @authCookieName.inject coldbox:setting:AUTH_COOKIE_NAME
	 */
	public SecurityService function init(
		required string jwtSecret,
		required string jwtIssuer,
		required string jwtExpirationinMinutes,
		required string authCookieName
	) {

		variables.jwt =  new lib.jwt.JWT( key = jwtSecret, issuer = jwtIssuer );
		variables.JWT_ISSUER = arguments.jwtIssuer;
		variables.JWT_EXP_MIN = arguments.jwtExpirationinMinutes;
		variables.AUTH_COOKIE_NAME = arguments.authCookieName;

		return this;
	}

	/**
	 * Check user credentials
	 */
	public boolean function checkUserCredentials( required string username, required string password ) {

		var validCredentials = false;

		var user = wirebox.getInstance( "User" ).firstWhere( "username", arguments.username );

		if ( isNull( user) ) {
			bcrypt.hashPassword( arguments.password );
			return false;
		}
		else {
			validCredentials = bcrypt.checkPassword( arguments.password, user.getPassword() );
		}

		return validCredentials;
	}

	/**
	 * Issue an authentication cookie
	 */
	public void function issueAuthCookie( required string username ) {
		//expiration https://trycf.com/scratch-pad/gist/349e457bd8fa4a8b77560051ed49a447
		var authTokenPayload = {
			"iss" = JWT_ISSUER,
			"exp" = int( dateAdd( "n", JWT_EXP_MIN, now() ).getTime() / 1000 ),
			"sub" = arguments.username
		};
		var authToken = jwt.encode( authTokenPayload );
		cfheader( name="Set-Cookie", value="#AUTH_COOKIE_NAME#=#authToken#;Max-Age=#(int(JWT_EXP_MIN * 60))#;path=/;domain=#listFirst( CGI.HTTP_HOST, ':' )#;HTTPOnly" );
	}

	/**
	 * Get an authentication token
	 */
	public struct function getAccessToken( required string username ) {
		//expiration https://trycf.com/scratch-pad/gist/349e457bd8fa4a8b77560051ed49a447
		var authTokenPayload = {
			"iss" = JWT_ISSUER,
			"exp" = int( dateAdd( "n", JWT_EXP_MIN, now() ).getTime() / 1000 ),
			"sub" = arguments.username
		};

		return {
			"tokenType" = "Bearer",
			"expiresIn" = int(JWT_EXP_MIN * 60),
			"accessToken" = jwt.encode( authTokenPayload )
		};
	}

	/**
	 * Check auth token
	 */
	public struct function verifyToken( required string token ) {
		var authResult = {
			validAccessToken = false,
			username = ""
		};

		try {
			var payload = jwt.decode( arguments.token );
			authResult.validAccessToken = true;
			authResult.username = payload.sub;
		}
		catch (any e) {}

		return authResult;
	}

	/**
	 * Delete auth cookie
	 */
	public struct function logout() {
		var authResult = {
			"success" = false,
			"message" = ""
		};
		
		if ( structKeyExists( cookie, AUTH_COOKIE_NAME) ) {
			structDelete( cookie, AUTH_COOKIE_NAME );
			cfheader( name="Set-Cookie", value="#AUTH_COOKIE_NAME#=;Max-Age=-1;path=/;domain=#listFirst( CGI.HTTP_HOST, ':' )#;HTTPOnly" );
			authResult.success = true;
		}
		else {
			authResult.message = "Auth cookie does not exist";
		}

		return authResult;
	}
}