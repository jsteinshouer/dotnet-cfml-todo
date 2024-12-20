component {
    
    function up( schema, query ) {

        schema.dropIfExists( "todo" );
        schema.dropIfExists( "user" );
        schema.create( "user", function(table) {
			table.increments( "user_id" );
			table.string( "username",50 );
			table.string( "password",150 );
		} );
        schema.create( "todo", function(table) {
			table.increments( "todo_id" );
			table.string( "title" );
            table.integer("user_id");
            table.bit("is_done");
            table.foreignKey( "user_id" ).references( "user_id" ).onTable( "user" );
		} );
    }

    function down( schema, query ) {

        schema.dropIfExists( "todo" );
        schema.dropIfExists( "user" );

    }

}
