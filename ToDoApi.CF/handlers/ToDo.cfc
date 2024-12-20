/**
* My RESTFul Event Handler
*/
component extends="BaseHandler" secured="true" {

	/**
	 * Runs before each action
	 */
	any function preHandler( event, rc, prc ){
		prc.user = getInstance("User")
			.where( "username", prc.authorizedUsername )
			.firstOrFail();
	}

	/**
	 * Index
	 */
	any function index( event, rc, prc ){
		prc.response.setData( prc.user.getToDos().map( (i) => { return i.getMemento(); }) );
	}


	/**
	 * Read a todo
	 */
	any function show( event, rc, prc ){
		var todo = getInstance( "ToDo" )
				.findOrFail( rc.id );
		if ( todo.getUserID() == prc.user.getID() ) {
			prc.response.setData( todo.getMemento() );
		}
		else {
			prc.response.setStatus( 403 );
		}
	}

	/**
	 * Create a new todo
	 */
	any function create( event, rc, prc ){

		event.paramValue("title","");
		event.paramValue("isDone",false);

		var todo = getInstance( "ToDo" ).create( {
			"title": rc.title,
			"isDone": rc.isDone,
			"userId": prc.user.getID()
		});

		prc.response.setData( todo.getMemento() );
		prc.response.setStatusCode( 201 );
	}

	/**
	 * Update a todo
	 */
	any function update( event, rc, prc ){
		event.paramValue("title","");
		event.paramValue("isDone","");

		var todo = prc.user.todos()
			.findOrFail( rc.id )
			.update( {
				"title": rc.title,
				"isDone": rc.isDone
			});

		prc.response.setData( todo.getMemento() );
		prc.response.setStatusCode( 200 );
	}

	/**
	 * Delete a todo record
	 */
	any function delete( event, rc, prc ){

		var todo = getInstance( "ToDo" ).findOrFail( rc.id );
		if ( todo.getUserID() == prc.user.getID() ) {
			todo.delete();
			prc.response.setStatusCode( 200 );
		}
		else {
			prc.response.setStatus( 403 );
		}
	}

}