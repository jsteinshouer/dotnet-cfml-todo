/**
 * Security Interceptor
 */
component extends="coldbox.system.Interceptor"{

    property name="handlerService" inject="coldbox:handlerService";
    property name="securityService" inject="provider:security.SecurityService";
    property name="AUTH_METHOD" inject="coldbox:setting:AUTH_METHOD";
    property name="AUTH_COOKIE_NAME" inject="coldbox:setting:AUTH_COOKIE_NAME";


    function configure(){}
    
    /**
	 * Use preProcess to check authorization 
	 *
	 * @event
	 * @interceptData
	 * @rc
	 * @prc
	 * @buffer
	 */
	function preProcess( event, interceptData, rc, prc, buffer ){

        prc.response = wirebox.getInstance( "api.Response" );

        var handlerBean = handlerService.getHandlerBean( event.getCurrentEvent() );
        handlerService.getHandler( handlerBean, arguments.event );
        var securedHandler = handlerBean.getHandlerMetadata("secured", false);

        if ( isBoolean(securedHandler) && securedHandler ) {
            var token = "";
            if ( AUTH_COOKIE_NAME.len() && cookie.keyExists(AUTH_COOKIE_NAME) ) {
                token = cookie[AUTH_COOKIE_NAME];
            }
            else if ( event.getHTTPHeader( header="Authorization", defaultValue="" ) != "" ) {
                token = listLast( event.getHTTPHeader( header="Authorization", defaultValue="" ), " " );
            }
            var authResult = securityService.verifyToken( token );
            if ( authResult.validAccessToken ) {
                prc.authorizedUsername = authResult.username;
            }
            else {
                arguments.event.getResponse()
                    .setError( true )
                    .setStatusCode( 401 )
                    .setStatusText( "Unauthorized" )
                    .setData({});
                event.renderData(
                    type            = arguments.prc.response.getFormat(),
                    data            = arguments.prc.response.getDataPacket(),
                    contentType     = arguments.prc.response.getContentType(),
                    statusCode      = arguments.prc.response.getStatusCode(),
                    statusText      = arguments.prc.response.getStatusText(),
                    location        = arguments.prc.response.getLocation(),
                    isBinary        = arguments.prc.response.getBinary(),
                    jsonCallback    = arguments.prc.response.getJsonCallback()
                ).noExecution();
            }
        }

    }
}