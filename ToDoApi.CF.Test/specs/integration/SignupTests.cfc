/*******************************************************************************
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
component extends="BaseintegrationTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here

	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Test Signup", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
			});

            describe( "POST /register", function(){

				it( "should create a new user on successful signup", function(){

					var event = post(
						route = "/api/register",
						params = {
							"username": "jdoe@example.com",
							"password": "%Gt6Iok4!hhaR"
						}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 201 );
					expect(	response.getData().id ).toBeGT( 0 );
					expect(	response.getData().username ).toBe( "jdoe@example.com" );
				});

                
				it( "should not let a user signup with a weak password", function(){

					var event = post(
						route = "/api/register",
						params = {
							"username": "jwhite",
							"password": "password1"
						}
					);


					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 400 );
					expect(	response.getError() ).toBe( true );
					expect(	response.getMessages().len() ).toBeGT( 0 );
	
				});

                                
				it( "should not let a user signup with an username that already exists", function(){
                    
					var user = getInstance( "User" ).create( {
							"username": "jwhite",
							"password": "123456"
					});

					var event = post(
						route = "/api/register",
						params = {
							"username": "jwhite",
							"password": "%Gt6Iok4!hhaR"
						}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 400 );
					expect(	response.getError() ).toBe( true );
					expect(	response.getMessages()[1] ).toBe( "An account already exists for jwhite." );
	
				});

			});



		});

	}

}