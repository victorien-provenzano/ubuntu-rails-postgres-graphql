source /home/vagrant/.sandbox.conf.sh

echo "Installing Datadog Agent 6 from api_key: ${DD_API_KEY} but not starting it..."
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${DD_API_KEY} DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"


echo "Installing the rbenv and Ruby dependencies"
sudo apt-get -y update
sudo apt-get -y install curl git-core python-software-properties ruby-dev libpq-dev build-essential nginx libsqlite3-0 libsqlite3-dev libxml2 libxml2-dev libxslt1-dev libreadline-dev postgresql postgresql-contrib imagemagick
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install nodejs

echo "Installing rbenv"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"'               >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

echo "Installing ruby"
sudo -H -u vagrant bash -i -c 'rbenv install 3.0.0'
sudo -H -u vagrant bash -i -c 'rbenv global 3.0.0'
sudo -H -u vagrant bash -i -c 'gem install bundler'

echo "Installing rails"
sudo -H -u vagrant bash -i -c 'gem install rails -v 6.1.1'

echo "Installing yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update && sudo apt install yarn

cd data/blog/

sudo -H -u vagrant bash -i -c 'bundle install'
sudo -H -u vagrant bash -i -c 'yarn install'

echo "Setting up the postgres db"

sudo -u postgres createuser -s vagrant
sudo -H -u vagrant bash -i -c 'rails db:create'
sudo -H -u vagrant bash -i -c 'rails db:migrate'
sudo -H -u vagrant bash -i -c 'rails db:seed'
