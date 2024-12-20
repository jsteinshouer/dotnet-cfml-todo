/**
* ToDo Bean
*/
component extends="quick.models.BaseEntity" accessors="true" table="todo" {

	property name="id" column="todo_id";
	property name="title";
	property name="isDone" column="is_done";
	property name="userID" column="user_id";

    //Use ReturningKeyType because sqlite-jdbc stopped supporting getGeneratedKeys in https://github.com/xerial/sqlite-jdbc/releases/tag/3.43.0.0
    //  which caused AutoIncrementingKeyType to not work   
    function keyType() {
        return variables._wirebox.getInstance( "ReturningKeyType@quick" );
    }

    function user() {
	    return belongsTo( "User" );
	}

}