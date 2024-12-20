/**
* My Event Handler Hint
*/
component extends="coldbox.system.EventHandler"{

	property name="userService" inject="users.UserService";
	property name="securityService" inject="security.SecurityService";
	property name="captchaService" inject="security.CaptchaService";
	property name="passwordEstimator" inject="security.PasswordStrengthEstimator";
	
	/**
	* Executes before all handler actions
	*/
	any function preHandler( event, rc, prc, action, eventArguments ){
		prc.RECAPTCHA_ENABLED = getSetting("RECAPTCHA_ENABLED");
		prc.RECAPTCHA_SITE_KEY = getSetting("RECAPTCHA_SITE_KEY");
	}

	/**
	* login
	*/
	any function login( event, rc, prc ){

		prc.message = "";
		
		event.setView("security/login");
	}

	/**
	* logout
	*/
	any function logout( event, rc, prc ){
		securityService.logout();
		relocate("login");
	}

	/**
	* authenticate
	*/
	any function authenticate( event, rc, prc ) {

		event.paramValue("username","");
		event.paramValue("password","");
		event.paramValue("g-recaptcha-response","");
		prc.message = "";

		if ( !prc.RECAPTCHA_ENABLED || captchaService.verify( event.getValue("g-recaptcha-response") ) ) {

			var step1Valid = securityService.checkUsernameAndPassword(rc.username,rc.password);	

			if (step1Valid) {
				if ( securityService.isStep2Required() ) {
					relocate("login/step2");
				}
				else {
					relocate("recipes");
				}
			}
			else {
				prc.message = "The username and password combination is invalid!";
				event.setView("security/login");
			}
		}
		else {
			prc.message = "Invalid request!";
			event.setView("security/login");
		}
		
	}

	any function step2( event, rc, prc ) {

		if ( securityService.isStep1Valid() ) {
			event.setView("security/step2");
		}
		else {
			relocate("login");
		}
		
	}

	any function verifyCode( event, rc, prc ) {

		event.paramValue("passcode","");

		if ( securityService.isStep1Valid() && len( rc.passcode )  ) {

			if ( securityService.verifyOneTimePassword( rc.passcode ) ) {
				relocate("recipes");
			}
			else {
				securityService.logout();
				prc.message = "Two-factor authentication failed.";
				event.setView("security/login");
			}
			
		}
		else {
			relocate("security.login");
		}
		
	}

	any function estimatePasswordStrength( event, rc, prc ) {

		event.paramValue("password","");

		return serializeJSON( passwordEstimator.estimate( rc.password ) );		
	}
	
	
}