/**
 * My RESTFul Event Handler
 */
component extends="BaseHandler" {

	property name="securityService" inject="security.SecurityService";
	property name="AUTH_METHOD" inject="coldbox:setting:AUTH_METHOD";

	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only      = "";
	this.prehandler_except    = "";
	this.posthandler_only     = "";
	this.posthandler_except   = "";
	this.aroundHandler_only   = "";
	this.aroundHandler_except = "";

	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {};

	/**
	 * Authenticate a user
	 *
	 * @x-route (POST) /api/login
	 */
	function index( event, rc, prc ) {

		if ( rc.keyExists("email") && !rc.keyExists("username")  ) {
			rc.username = rc.email;
		}

		if ( securityService.checkUserCredentials( rc.username, rc.password ) ) {
			prc.response.setStatusCode( 200 );
			prc.response.setData({
				"isLoggedIn": true,
				"expires": ""
			});
			if ( AUTH_METHOD == "cookie" ) {
				securityService.issueAuthCookie( username=rc.username );
			}
			else {
				prc.response.setData( securityService.getAccessToken( username=rc.username ) );
			}
		}
		else {
			prc.response.setStatusCode( 401 );
			prc.response.setStatusText( "Unauthorized" );
		}
	}

	/**
	 * Delete the session cookie
	 *
	 * @x-route (GET) /api/logout
	 */
	function logout( event, rc, prc ) {

		var result = securityService.logout();
		prc.response.setStatusCode( 200 );
		prc.response.setData(result);

	}

}
