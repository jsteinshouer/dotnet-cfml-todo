component{

	function configure(){
		setFullRewrites( true );

        // A nice healthcheck route example
		route( "/healthcheck", function( event, rc, prc ) {
			return "Ok!";
		} );

		addNamespace( namespace="api", pattern="/api" );
		route( "/engine")
		.withNamespace("api")
		.toResponse( body = "{ ""engine"": ""CFML"" }", statusCode=200, statusText="ok" );
		// API Echo
		route( "/echo")
			.withNamespace("api")
			.withAction({
				GET: "index" 
			})
			.toHandler("Echo");

		route( "/register")
			.withNamespace("api")
			.withAction({
				POST: "index" 
			})
			.toHandler("Signup");
		route( "/logout")
			.withNamespace("api")
			.withAction({
				GET: "logout" 
			})
			.toHandler("Authorize")
		route( "/login")
			.withNamespace("api")
			.withAction({
				POST: "index" 
			})
			.toHandler("Authorize")

		resources( resource="ToDo", namespace="api" );

		route(pattern=".*",handler="Main",action="index").end();
	}

}