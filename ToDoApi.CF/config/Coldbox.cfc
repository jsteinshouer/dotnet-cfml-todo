component{

	/* Use java system to get settings from env */
	javaSystem = createObject( 'java', 'java.lang.System' );

	/* Load .env file properties into Java system properties variables */
	private void function loadEnvProperties() {
		/* Load .env file into Environment variables */
		var basePath = getDirectoryFromPath(getCurrentTemplatePath());
		var rootPath = REReplaceNoCase( basePath, "config(\\|/)", "" );
		if ( fileExists("#rootPath#/.env") ) {

			//load the environment properties file
			var fis = createObject( 'java', 'java.io.FileInputStream' ).init( "#rootPath#/.env" );
			var propertyFile = createObject( 'java', 'java.util.Properties' ).init();
			propertyFile.load( fis );
			fis.close();

			/* Append/overrite current settings */
			for ( var key in propertyFile ) {
				javaSystem.setProperty( key, propertyFile[ key ] );
			}

		}
	}

	// Configure ColdBox Application
	function configure(){


		// coldbox directives
		coldbox = {
			//Application Setup
			appName 				= "ToDo",
			eventName 				= "event",

			//Development Settings
			reinitPassword			= "",
			handlersIndexAutoReload = false,

			//Implicit Events
			defaultEvent			= "Main.index",
			requestStartHandler		= "",
			requestEndHandler		= "",
			applicationStartHandler = "Main.onAppStart",
			applicationEndHandler	= "",
			sessionStartHandler 	= "",
			sessionEndHandler		= "",
			missingTemplateHandler	= "",

			//Extension Points
			applicationHelper 			= "",
			viewsHelper					= "",
			modulesExternalLocation		= [],
			viewsExternalLocation		= "",
			layoutsExternalLocation 	= "",
			handlersExternalLocation  	= "",
			requestContextDecorator 	= "",
			controllerDecorator			= "",

			//Error/Exception Handling
			exceptionHandler		= "",
			onInvalidEvent			= "",
			customErrorTemplate		= "",

			//Application Aspects
			handlerCaching 			= true,
			eventCaching			= true,
			proxyReturnCollection 	= false
		};

		loadEnvProperties();

		// custom settings
		settings = {
			JWT_SECRET = getSystemSetting("JWT_SECRET"),
			JWT_ISSUER = getSystemSetting("JWT_ISSUER"),
			JWT_EXP_MIN = getSystemSetting("JWT_EXP_MIN"),
			AUTH_METHOD = getSystemSetting("AUTH_METHOD", "cookie"),
			AUTH_COOKIE_NAME = getSystemSetting("AUTH_COOKIE_NAME"),
			DEBUG_MODE = isBoolean( getSystemSetting("DEBUG_MODE", false) ) ? getSystemSetting("DEBUG_MODE", false) : false,
			htmlhelper_js_path = "",
			htmlhelper_css_path = ""	
		};

		// Module Directives
		modules = {
			//Turn to false in production
			autoReload = false,
			// An array of modules names to load, empty means all of them
			include = [],
			// An array of modules names to NOT load, empty means none
			exclude = []
		};

		//LogBox DSL
		logBox = {
			// Define Appenders
			appenders = {
				coldboxTracer = { class="coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root = { levelmax="INFO", appenders="*" },
			// Implicit Level Categories
			info = [ "coldbox.system" ]
		};

		//Layout Settings
		layoutSettings = {
			defaultLayout = "",
			defaultView   = ""
		};

		//Interceptor Settings
		interceptorSettings = {
			throwOnInvalidStates = false,
			customInterceptionPoints = ""
		};

		//Register interceptors as an array, we need order
		interceptors = [ 
			{
				class="interceptors.Security",
				properties={}
			}
		];

		moduleSettings = {
			quick = {
				defaultGrammar = "#getSystemSetting("DB_GRAMMAR","SQLiteGrammar")#@qb"
			},
			qb = {
				defaultGrammar = "#getSystemSetting("DB_GRAMMAR","SQLiteGrammar")#@qb"
			},
			"cfmigrations" : {
				"managers" : {
					"default" : {
						// The manager handling and executing the migration files
						"manager" : "cfmigrations.models.QBMigrationManager",
						// The directory containing the migration files
						"migrationsDirectory" : "/resources/database/migrations",
						// The directory containing any seeds, if applicable
						"seedsDirectory" : "/resources/database/seeds",
						// A comma-delimited list of environments which are allowed to run seeds
						"seedEnvironments" : "development",
						"properties" : {
							"defaultGrammar" : "#getSystemSetting("DB_GRAMMAR","SQLiteGrammar")#@qb"
						}
					}
				}
			}
		}
	}

	/**
	* Development environment
	*/
	function detectEnvrionment(){
		return getSystemSetting( "ENVIRONMENT", "production" );
	}

	/**
	* Development environment
	*/
	function development(){
		coldbox.customErrorTemplate = "/coldbox/system/exceptions/Whoops.cfm";
		coldbox.reinitPassword = "";
		coldbox.handlerCaching = false;
		coldbox.handlersIndexAutoReload = true;
		coldbox.eventCaching = false;
		coldbox.debugMode = settings.DEBUG_MODE;

	}

}