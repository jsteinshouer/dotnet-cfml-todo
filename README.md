# CFML Compared to .NET

Compares creating an API using CFML and .NET.

## CFML Backend API

### Requirements

- CommandBox

## .NET Backend API

### Install dependencies

```bash
cd ToDoApi.CF
box install
```

### Run the CFML backend

```bash
cd ToDoApi.CF
box server start
```

### Requirements

- .NET CLI v8
- .NET SDK v8

### Run the .NET Backend

```bash
cd ToDoApi.NET
dotnet run
```

## Front-end (Angular)

### Requirements

- Node.js v18+

### Install dependencies

```bash
cd ToDoApp
npm install
```

### Run the front-end and proxy backend requests to .NET API (Dont forget to start the .NET API application)

```bash
ng serve --poll 500 --port 4001 --proxy-config proxy.net.json
```

The app should be available at http://localhost:4001.

### Run the front-end and proxy backend requests to CFML API (Dont forget to start the CFML API application)

```bash
ng serve --poll 500 --port 4002 --proxy-config proxy.cf.json
```

The app should be available at http://localhost:4002.


## Testing

### CF Unit and Integration Tests

With the CF backend running you can run the unit tests at http://localhost:5002/tests/runner.cfm. The tests are located in the `TodDoApi.CF.Test` folder.

### .NET Unit and Integration Tests

You can run them in the CLI or use the Test Explorer in VS Code.

```
cd ToDoApi.NET.Test/
dotnet test
```
