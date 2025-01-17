﻿/*******************************************************************************
*	Integration Test as BDD (CF10+ or Railo 4.1 Plus)
*
*	Extends the integration class: coldbox.system.testing.BaseTestCase
*
*	so you can test your ColdBox application headlessly. The 'appMapping' points by default to
*	the '/root' mapping created in the test folder Application.cfc.  Please note that this
*	Application.cfc must mimic the real one in your root, including ORM settings if needed.
*
*	The 'execute()' method is used to execute a ColdBox event, with the following arguments
*	* event : the name of the event
*	* private : if the event is private or not
*	* prePostExempt : if the event needs to be exempt of pre post interceptors
*	* eventArguments : The struct of args to pass to the event
*	* renderResults : Render back the results of the event
*******************************************************************************/
component extends="BaseIntegrationTest" appMapping="/root"  {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll() {
		super.beforeAll();
		// do your own stuff here
		util = new coldbox.system.core.util.Util();
		jwt = new lib.jwt.JWT( key = util.getSystemSetting("JWT_SECRET"), issuer = util.getSystemSetting("JWT_ISSUER") );
		var authTokenPayload = {
			"iss" = util.getSystemSetting("JWT_ISSUER"),
			"exp" = dateAdd( "n", util.getSystemSetting("JWT_EXP_MIN"), now() ).getTime(),
			"sub" = "user@example.com"
		};
		mockAuthToken = jwt.encode( authTokenPayload );
	}

	function afterAll() {
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run() {
		describe( "My RESTFUl Service", function() {
			beforeEach( function( currentSpec ) {
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				//Create mock auth cookie
				// cookie[ util.getSystemSetting( "AUTH_COOKIE_NAME" ) ] = mockAuthToken
			} );
			
			afterEach( function( currentSpec ) {
				// structDelete( cookie, util.getSystemSetting( "AUTH_COOKIE_NAME" ), false );
				// to prevent the cookie from being sent to the browser
				getPageContext().getResponse().reset();
			} );

			it( "can handle an echo", function() {
				prepareMock( getRequestContext() ).$( "getHTTPMethod", "GET" );
				var event    = get( route = "api/echo", params = { message = "Welcome to the Jungle!!"}, headers = { "Authorization" = "Bearer #mockAuthToken#"} );
				var response = event.getPrivateValue( "response" );
				expect( response.getError() ).toBeFalse();
				expect( response.getData() ).toBe( "Welcome to the Jungle!!" );
			} );

		} );

	}

}