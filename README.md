# WebDB-group8
### Documentation

## How to Run

### If the database is built
```bash
docker-compose up
```
### If the database is not built/ on an old build
```bash
docker-compose down -v
docker-compose up --build
```
## How to check
### If the backend is not running
### 1. Docker says: 
```fitness_db | LOG: database system is ready to accept connections```
### 2. After using
 ``` 
docker ps
 ```
  ``` fitness_db ``` is listed as running.
### If the backend is running
Calling functions like login or register will say database error if the database is not running.

## Important features
- Tables are linked together with foreign keys. This helps with making the connection between the tables, for example which user performed which workout.
- Indexes are created to help speed up common queries.
- Functions are created in the database. Instead of the backend using queries, it just calls the function. This helps with reducing errors by making debugging easier.

## What to call
### The backend connects using the environment variables defined in ``` docker-compose.yml ```:
- Host: ``` localhost ```
- Port: ``` 5432 ```
- Database: ``` fitness_db ```
- User: ``` fitness_user ```
- Password: ``` fitness_pass ```
### Why:
- To ensure a secure connection between the database and the backend, while preventing unwanted direct access.
- Easy to update in case of changes to the environment variables.

## Why This Works 
- The data can be easily modified or expanded on, since the database is isolated.
- Operations are predictable and easy to maintain, since they are handled by the functions.
- The relationship between the tables makes sure that the data stays consistent as new data gets added.
- The connection from the backend to the database is done through the environment variables, which means there is only one point of configuration for the host, port, database name, user, and password.


