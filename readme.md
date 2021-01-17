## Ruby on Rails with GraphQL & Postgres

![Sample trace](https://p-qkfgo2.t2.n0.cdn.getcloudapp.com/items/7KubKjzw/9bd50652-e0c2-4f3c-b10a-d8e3c168eeee.png?v=624e198fc4e4d5f372c56f31dfda0a49)

**Versions:**
- Ruby 3.0.0
- Rails 6.1.1
- Node 12.20.1
- Graphql 1.11.6

This spins up an Rails 6.1.1 app with the basic CRUD operators using postgres and a graphql endpoint

It creates a link to your **actual data folder** so you can make real time changes. However, this also means if you delete files, it'll delete files in your actual folder too, so be careful!

### Step 1: Set up the keys

Make sure that you set up `~/.sandbox.conf.sh` before going through this sandbox. The instructions can be found in https://github.com/DataDog/sandbox/#start-any-vm-in-2-min. 

### Step 2: Getting into the box

To get in the box, run:

```
vagrant up
vagrant ssh
```

### Step 3: Spinning up the Rails App

The tracer initialization code is in `blog/config/initializers/datadog.rb` and `blog/app/graphql/blog_schema.rb` (for the graphql integration)

```
cd /home/vagrant/data/blog
rails s -b 0.0.0.0
```

This is what you should see:

```
=> Booting Puma
=> Rails 6.1.1 application starting in development 
=> Run `bin/rails server --help` for more startup options
Puma starting in single mode...
* Puma version: 5.1.1 (ruby 3.0.0-p0) ("At Your Service")
*  Min threads: 5
*  Max threads: 5
*  Environment: development
*          PID: 18066
* Listening on http://0.0.0.0:3000
Use Ctrl-C to stop
```

**Making requests**

To make requests, `curl "localhost:3000"` in a different terminal or go to your browser at `localhost:3000`.

***Automatic instrumentation spans:***

- `localhost:3000`
- `localhost:3000/articles/new`
- `localhost:3000/articles/#{id}/edit`

***Custom instrumentation spans:***

- `localhost:3000/articles/#{id}`

***Graphql Endpoint:***

- `localhost:3000/graphiql`

- write the following query and press play:

```
query {
  fetchArticles {
    id
    title
    body
  }
}
```

Note: you can also directly navigate the app from the browser

### Step 4: Additional configurations

**Configure trace and log connection**

- Tracer side: Logging with lograge, and trace_id injection have been configured in `blog/config/initializers/lograge.rb`

- Agent side: Logging has been configured in `datadog.yaml` and `conf.d/ruby.d/conf.yaml`

**Configure infrastructure metrics**

- Tracer side: Infrastructure metrics have been configured in `blog/config/initializers/datadog.rb`

- Agent side: Infrastructure metrics have been configured in `datadog.yaml`

**Configure versioning**

- Versioning has been configured in `blog/config/initializers/datadog.rb`

### Step 5: Changing the ruby version

In order to replicate an issue, you may need to change the ruby version being used in this sandbox

Note: ruby was installed with rbenv, a version management tool that makes it easy to change the ruby version

- Step 1: Figure out which version you would like to use

```
# list latest stable versions:
rbenv install -l

# list all local versions:
rbenv install -L
```

- Step 2: Install a ruby version

```
# install a Ruby version:
rbenv install <VERSION>
```

- Step 3: Set this ruby version in your project directory

```
cd data/blog
rbenv local <VERSION>
```

- Step 4: Install shims for all Ruby executables

```
rbenv rehash
```

Note: once you have done this, running `ruby -v` should return the new version you have installed!

- Step 5: Change the version of ruby in your Gemfile
```
ruby '<VERSION>'
```

- Step 6: Install bundler with your new version of ruby
```
gem install bundler
```

- Step 7: Run bundle install & yarn install
```
bundle install
yarn install
```

And that's it! Now, when you run `rails s -b 0.0.0.0` you should see your new ruby version:
```
* Puma version: 5.1.1 (ruby <VERSION>) ("At Your Service")
```

### Step 6: Spinning down the application

The application can be stopped with `Control + C`.

### Step 7: To destroy the vagrant box

```
exit
vagrant destroy
```

Note: if you have made changes to the data folder, but would like to return back to the inital state run `git fetch --all` and `git reset --hard origin/master
`
### Resources
1. Rails: https://guides.rubyonrails.org/getting_started.html
2. Lograge: https://docs.datadoghq.com/logs/log_collection/ruby/
3. Postgres: https://www.postgresql.org/docs/
4. Graphql: https://graphql.org/
5. dd-trace-rb: https://github.com/DataDog/dd-trace-rb
6. rbenv: https://github.com/rbenv/rbenv
