# Code Grader
Demo can be found here https://code-grader.herokuapp.com
## Install
### Install docker
https://docs.docker.com/get-docker/

### Clone the repository

```shell
git clone git@github.com:islamodeh/code_grader.git
cd code_grader/
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 2.6`

If not, install the right ruby version using rvm(it could take a while):

```shell
rvm install 2.6
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler) and [Yarn](https://github.com/yarnpkg/yarn):

```shell
bundle install
```

### Initialize the database
- copy cofig/database.example.yml to config/database.yml and add your DB credentials.
```shell
rails db:create db:migrate db:seed
```

### Prepare Docker Images
* Make sure docker is running locally
```shell
rake os:prepare_c_vm
```

## Run the server

```shell
rails s
```
Check http://localhost:3000
