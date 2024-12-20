/**
 * Helper for HTTP requests
 */
component singleton {

    /**
     * Get headers for the inbound HTTP request
     */
    public struct function getRequestHeaders() {
        return GetHttpRequestData().headers;
    }
    
}