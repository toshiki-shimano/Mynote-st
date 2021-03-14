# ノコギリエラー

◍`An error occurred while installing nokogiri (1.10.10), and Bundler cannot continue.Make sure that gem install nokogiri -v '1.10.10' --source 'https://rubygems.org/' succeeds before bundling.`  
というエラー。
◍sudo bundle installは問題ないのに、bundleと打つとノコギリエラーに。

* 以下のコマンドを試してみた

```error
sudo gem install nokogiri
sudo gem install nokogiri -v '1.10.10
bundle install --path vendor/bundle
sudo apt-get install libxslt1-dev
sudo apt-get install libxml2-dev
sudo apt install libpq-dev
sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev
sudo apt-get install build-essential patch zlib1g-dev liblzma-dev libxslt1-dev libxml2-dev
bundle config build.nokogiri --use-system-libraries
```

⇒これら全てを打って、  
①gem install rails
②sudo bundleとやったらnokogiriがインストールされた。
