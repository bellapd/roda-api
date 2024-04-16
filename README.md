# roda-api

## Description
As I exploring the creation of APIs with the Ruby Roda framework, I decided to create a simple API that allows users to create, read, update, and delete (CRUD) records in a database. This API is related with a project that I am currently working on called 'Navitogether'.

## Installation
1. Clone the repository

    ```bash
        git clone https://github.com/<your-username>/roda-api.git
    ```

2. Install the require gems
    
    ```bash
        bundle install
    ```

3. Start the Roda server:
    ```bash
        rackup config.ru
    ```
> The API should now be running on `http://localhost:9292`.

## Usage

The API currently supports the following operations:

1. **Get Location and Users**

```bash
    curl -X GET http://localhost:9292/locations/1
```
