component {

    property name="bcrypt" inject="@BCrypt";

    function run( qb, mockdata ) {

        qb.newQuery().from("todo").delete();
        qb.newQuery().from("user").delete();

        qb.newQuery().table( "user" ).insert([
            "username": "me@example.com",
            "password": bcrypt.hashPassword( "P@ssword1" )
        ]);

        

        var userQuery = qb.newQuery().select(["user_id"]).from("user").where("username","=","me@example.com").get();
        var data = [
            {
                "title" = "Mow the lawn",
                "isDone" = false
            },
            {
                "title" = "Do the dishes",
                "isDone" = false
            }
        ];

        for ( var item in data ) {
            item.user_id = userQuery[1].user_id;
            qb.newQuery().table( "todo" ).insert(item);
        }

    }

}