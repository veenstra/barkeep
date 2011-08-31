Overview
========
Coming soon!

Setting up Barkeep for development
==================================
    pip install pygments
    gem install bundler
    bundle install
    port install nodejs # or brew install node
    curl http://npmjs.org/install.sh | sh # install npm
    npm install less
    run_migrations.sh # db migrations
    bin/rerun.sh # run the server
    navigate to localhost:4567/commits

If you're running a Mac using Macports with rvm, ensure your ruby is compiled against the macports openssl library. Otherwise you will get segfaults when sending emails over SSL:
rvm install 1.9.2 --with-openssl-dir=/opt/local

Deployment
==========
These packages will need to be installed on a linux server before a deploy will work. apt-get the following:

    mysql-server
    mysql-client
    libmysqlclient-dev
    sqlite3
    libsqlite3-dev
    openssl
    libopenssl-ruby
    libssl-dev
    python-setuptools

Also install:

    pip
    pygments