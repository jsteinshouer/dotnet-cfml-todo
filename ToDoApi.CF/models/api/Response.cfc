/**
 * Custom API response object
 */
component extends="coldbox.system.web.context.Response" accessors="true" {
    
    /**
	 * Returns a standard response formatted data packet using the information in the response
	 *
	 * @reset Reset the 'data' element of the original data packet
	 */
	any function getDataPacket( boolean reset = false ){
		
        var hasError = getError() ? true : false;

        if ( !hasError ) {
            var packet = getData();
        }
        else {
            var packet = {
                "error"      : getError() ? true : false,
			    "messages"   : getMessages()
            };
        }

        if ( getPagination().totalPages > 1 ) {
            packet["pagination"] = getPagination();
        }

		return packet;
	}

}