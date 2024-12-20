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
component extends="BaseIntegrationTest" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		super.beforeAll();
		// do your own stuff here
		util = new coldbox.system.core.util.Util();
		jwt = new lib.jwt.JWT( key = util.getSystemSetting("JWT_SECRET"), issuer = util.getSystemSetting("JWT_ISSUER") );
		var authTokenPayload = {
			"iss" = util.getSystemSetting("JWT_ISSUER"),
			"exp" = dateAdd( "n", util.getSystemSetting("JWT_EXP_MIN"), now() ).getTime(),
			"sub" = "test@example.com"
		};
		testUser = {
			"username": "test@example.com",
			"password": "turnitto11"
		};
		mockAuthToken = jwt.encode( authTokenPayload );
	}

	function afterAll(){
		// do your own stuff here
		super.afterAll();
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){

		describe( "Test ToDo Resource", function(){

			beforeEach(function( currentSpec ){
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				//Create mock auth cookie
				// cookie[ util.getSystemSetting( "AUTH_COOKIE_NAME" ) ] = mockAuthToken;

			});

			describe( "GET /todo/:id", function(){

				it( "should get a todo", function(){
					var user = getInstance( "User" ).create(testUser);

					var todo = getInstance( "ToDo" ).create( {
						"title": "My ToDo Title",
						"isDone": false,
						"userID": user.getID()
					});

					var event = get( route = "api/todo/" & todo.getID(), headers = { "Authorization" = "Bearer #mockAuthToken#"}  );

					
					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().id ).toBe( todo.getID() );
					expect(	response.getData().title ).toBe( "My ToDo Title" );

				});

			});


			describe( "GET /todos", function(){

				it( "should list existing todos", function(){

					var user = getInstance( "User" ).create(testUser);

					var todo = getInstance( "ToDo" );

					todo.create( {
						"title": "Test 1",
						"isDone": false,
						"userID": user.getID()

					});
					todo.create( {
						"title": "Test 2",
						"isDone": false,
						"userID": user.getID()
					});

					var event = get( route = "api/todo", headers = { "Authorization" = "Bearer #mockAuthToken#"} );

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().len() ).toBe( 2 );
					expect(	response.getData()[1].title ).toBe( "Test 1" );

				});

			});


			describe( "POST /todo", function(){

				it( "should create a new todo", function(){
					var user = getInstance( "User" ).create(testUser);

					var event = post(
						route = "api/todo",
						params = {
							title = "Test ToDo Title",
							isDone = false
						},
						headers = { "Authorization" = "Bearer #mockAuthToken#"}
					);

					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 201 );
					expect(	response.getData().id ).toBeGT( 0 );
					expect(	response.getData().title ).toBe( "Test ToDo Title" );
				});

			});

			describe( "PUT /todo/:id", function(){

				it( "should get a todo", function(){
					var user = getInstance( "User" ).create(testUser);

					var todo = getInstance( "ToDo" ).create( {
						"title": "My ToDo Title",
						"isDone": false,
						"userID": user.getID()
					});

					var event = put( 
						route = "api/todo/" & todo.getID(),
						params = {
							title = "Change the Title",
							isDone = false
						},
						headers = { "Authorization" = "Bearer #mockAuthToken#"}
					);

					
					var response 	= event.getPrivateValue( "response" );
					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	response.getData().id ).toBe( todo.getID() );
					expect(	response.getData().title ).toBe( "Change the Title" );

				});

			});

			describe( "DELETE /todo", function(){

				it( "should delete todo record", function(){
					var user = getInstance( "User" ).create(testUser);

					var testToDo = getInstance( "ToDo" ).create( {
						"title": "Test 1",
						"isDone": false,
						"userID": user.getID()
					});

					var event = delete(
						route = "api/todo/#testToDo.getID()#",
						headers = { "Authorization" = "Bearer #mockAuthToken#"}
					);

					var response 	= event.getPrivateValue( "response" );

					expect(	response.getStatusCode() ).toBe( 200 );
					expect(	getInstance( "ToDo" ).find( testToDo.getID() ) ).toBeNull();
				});

			});


		});

	}

}