# RUNBOOK: Hello World
Hello world is an application build with Ruby/Sinatra. The applications is a CRUD API that interacts with Postgres via ActiveRecord.

## Install the pre-requisites

1. Install Docker

   * For [Mac OS X](https://docs.docker.com/v17.12/docker-for-mac/install/#install-and-run-docker-for-mac)
   * For Linux [Fedora](https://docs.docker.com/engine/install/fedora/)
      * Additianally install *docker-compose* via `sudo dnf install docker-compose`
   * For Linux [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
      * Additianally install *docker-compose* via `sudo apt install docker-compose`

1. Install Ruby

   * On Mac, via *Homebrew*
      ```shell
      $ brew install ruby
      ```
   * On Linux Fedora, via *dnf*
      ```shell
      $ dnf install ruby
      ```
   * On Linux Ubuntu, via *apt*
      ```shell
      $ apt install ruby
      ```

## Configure the application and its dependencies

1. Install the Ruby gems needed by the application:

   * Ruby
   * Sinatra
   * Rake
   * Active Record
   * Postgress

   1. Create a `Gemfile` and add the gems in the list above

      ```ruby
      # Gemfile
      source "http://rubygems.org"

      gem "sinatra"
      gem "sinatra-activerecord"
      gem "pg"
      gem "rake"
      ```

    1. Install the gems

      ```shell
      $ bundle install
      ```

1. To setup the application we should create a directory first, then `cd` into the directory and start to populate the directory with all the project files and all the configuration files for the runtime environment

   ```shell
   $ mkdir -p ~/tnedo
   $ cd ~/tnedo
   ```

1. Configure a simple Sinatra app (e.g. `hello world`)


   1. Require sinatra-activerecord in the application

      ```ruby
      # app.rb
      require "sinatra"
      require "sinatra/activerecord"

      class HelloWorld < Sinatra::Base
      ...
      ```

   1. Require sinatra-activerecord in the `Rakefile`

      ```ruby
      # Rakefile
      require "sinatra/activerecord"
      require "sinatra/activerecord/rake"
      require "./app"
      ```

   1. Requeire the application in the Rack configuration file

      ```ruby
      # config.ru
      require "./app"
      run HelloWorld
       ```

1. Add a Model (e.g. ["User"](https://github.com/sinatra-activerecord/sinatra-activerecord) or "Item" as explained here) which will be stored/managed in the database.

   1. Create the directory for the *models*

      ```shell
      $ mkdir models
      ```

   1. Create the model for the *"items"* table

      ```ruby
      # models/items.rb
      class Items < ActiveRecord::Base
      end
      ```

   1. Require the model *"items"* on the application

      ```
      # app.rb
      ...
      require "./models/items"

      ```

   1. Create the migration to the *"items"* table

      ```shell
      $ rake db:create_migration NAME=create_items
      ```

   1. Edit the file `db/migrate/<date_string>_create_items.rb` and add the colums to the migration

      ```ruby
      class CreateItems < ActiveRecord::Migration[6.1]
        def change
          create_table :items do |t|
            t.string :name
            t.string :value
          end
        end
      end
      ```

   1. Create a seed file

      ```ruby
      # db/seeds.rb
      items = [
        {name: "Book", value: "10"},
        {name: "Paper", value: "500"},
        {name: "Glue", value: "Out of stock"}
      ]

      items.each do |u|
        Items.create(u)
      end
      ```

### Running the application

1. Build & Run the application

   ```shell
   $ docker-compose up -d
   ```

1. Check the application is running

   ```shell
   $ docker-compose ps
            Name                       Command               State            Ports         
   -----------------------------------------------------------------------------------------
   tnedo_hello_1        bundle exec rackup --host  ...   Up       0.0.0.0:80->4567/tcp  
   tnedo_migrations_1   bash -c rake db:migrate && ...   Exit 0                         
   tnedo_postgres_1     docker-entrypoint.sh postgres    Up       0.0.0.0:5432->5432/tcp
   ```

## Provisioning the database

*docker-compose* takes care of the migrations and seeding. However if we need to add any additional task, then while inside the same directory, execute the command `rake` as follows:

```shell
$ docker-compose exec hello rake db:<command>
```

Where `<command>` can be any of `create`, `migrate`, `seed`, `reset`, `schema:load`, etc. 

## Accessing the application

Got to http://tnedo.bashlinux.com and you should be able to see tha application running

* The application is able CR operational
   * **Create:** The landing page presents a form to add items
   * **Read:** The `/read` path retrieves all the items

## Questions ?

If you are on this repo, you know how to reach me ;)
