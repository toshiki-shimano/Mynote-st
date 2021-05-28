# defとクラス

## 前知識(def)

★defの引数に「＊」を付けると可変長引数にできる

```ruby
def greeting(*name)
  "#{name.join('と')}、こんにちは！"
end
print greeting("田中さん", "鈴木さん", "佐藤さん")
#田中さんと鈴木さんと佐藤さん、こんにちは！
```

## クラス

### 前知識

★クラスとは、オブジェクトの設計図。クラスは、中にデータを保持でき、さらに保持しているデータを利用するメソッドをもつことができる。  
⇒クラスを元にして作成されたデータのかたまりをオブジェクトと呼ぶ（インスタンスとも）
🔺注意🔺:メソッドとの関係においては、オブジェクトはレシーバーともいう
⇒オブジェクトから取得できる属性をプロパティと呼ぶ
⇒クラスを作成する際に、セッターを付けなければ、勝手に中身を変更できない。ハッシュだけだと、簡単に追加できてしまう。  
⇒同じクラスのからオブジェクトを作成する場合、当引数を返ればそれぞれ違ったデータを持つ。  
(alice = User.new("alice", "20") と bob = User.new("bob", "30"))

### クラス作成

★🔶重要🔶：クラスの作成とインスタンスメソッドの関係  
①クラスは必ず大文字で始めます。クラスからオブジェクトを作成する場合は、.newをする  
②クラスのインスタンスメソッドを表記する場合は、「クラス名#メソッド名」（String#to_i）  
③クラス自体のクラスメソッドを表記する場合は、「クラス名.メソッド名 か クラス名::メソッド名」（File::exist?）

🔶重要🔶：.newすると必ず、initializeメソッドが呼ばれる。インタンスを初期したい時に定義する（このメソッドは特殊で外から呼べない：デフォルトでprivateメソッドになっている）
🔶超重要🔶：initializeメソッドに引数を付けたら、必ず.newする時にも引数を付けなくてはいけない（付けないと引数エラーになる）

★クラス内でメソッドを作成すると、そのクラスのインスタンスメソッドになる。（そのクラスから定義したメソッドを引き出すことができる）

★クラス内では、インスタンス変数を使うことができる
⇒必ず「@」で始める。スコープは基本そのインスタンス内。
⇒メソッド内やブロック内部で作成される変数をローカル変数と呼ぶ（その中のみ有効）

🔶重要🔶：ここで流れを掴む(理屈抜きにこの流れを暗記)

①クラスを設定して、インスタンスの初期化をするためにinitializeメソッドを定義  
②🔶重要🔶：クラス作成時に受け取る当引数を**使うために**、initialzeメソッドから、インスタンス変数へ入れる。これで、そのインスタンス変数は、その内部で使えるようになる（データが入る）  
③その変数をその中で、そのまま使ったり、新たにメソッドを定義してその中で使うこともできる  
④クラスが完成したら、.newと当引数を設定。  
⑤出力したい時は、pが必要
⑥因みに、ローカル変数は代入していないのにいきなり出したらエラーになるが、インスタンス変数は、エラーにならずnilになる。ある意味中身無しの変数としても使える。（この場合では、基本の流れの中でinitializeメソッド経由で変数を設定しないで）
⑦インスタンス変数は、外から基本参照はできない

```ruby
class User
    def initialize(name)
        @name = name
    end

    def hello
        "Hello, I am #{@name}"
    end
end

user = User.new("Alice")
p user.hello

# "Hello,I am Alice"
```

## セッター、ゲッターまとめ

★ゲッター（インスタンス変数を参照するために）

```ruby
class User
  def initialize(name)
    @name = name
  end

  def name #ゲッター
    @name  # このメソッド自体がインスタンス変数を呼ぶメソッドになっている。
  end      # つまり、attr_reader :nameとやればこのメソッドは作成する必要はない
end

user = User.new("Tom") 
user.name  #=>"Tom"
```

⇒色々説明があるが、クラス内でattr_readerかゲッターを設定するとそのクラス外から、クラスがインスタンスになったら、そのインスタンス外からその変数を参照できる。**Aインスタンス（ゲッターあり）のゲッターの変数をBインスタンスで参照できる。**  
⇒通常、インスタンス変数内の値はクラス外からでは参照できない。これをクラス外からでもインスタンス変数内の値を参照できるようにしたメソッドの事をゲッターという。

★セッター(インスタンス変数を変更するために)

⇒rubyは＝で終わるメソッドを定義すると、変数に代入するような形式でそのメソッドを呼ぶことができる（name=(str)  
⇒user.name = "Bob"が変数に代入しているように見えるが（変数に代入するような形式）、ここではname=メソッドを呼んでいる

```ruby
class User
  def initialize(name)
    @name = name
  end

  def name=(str) #セッター、ここで変更のために入ってきた値を再度用意してあるインスタンス変数に再代入する
    @name = str
  end
end

user = User.new("Tom") 
user.name = "Bob"  #=>"Bob"


def hello=(val) #こういうのもある
@hello = val 
end
```

⇒セッターのメソッドの引数に（name=(name)の(name)に） = で代入すると変更ができる。  
⇒通常、インスタンス変数内の値はクラス外からは更新ができない。これをクラス外からでもインスタンス変数内の値を更新できるようにしたメソッドのことをセッターといいます。※セッターは末尾に＝をつけるname=(name)

★アクセサメソッド

|定義式|機能|
|---|---|
|attr_reader :変数名|ゲッターと同じ役割を持つ。インスタンス変数内の値を参照する。|
|attr_writer :変数名|セッターと同じ役割を持つ。インスタンスな変数内の値を更新できるようにする。|
|attr_accessor :変数名|ゲッターとセッター両方の役割を持つ。インスタンス変数内の値を参照、更新できるようにする。|

⇒変数名はシンボル:変数名で渡す

```ruby
attr_reader :name  #ゲッター   
attr_writer :name #セッター
```

🔺注意🔺:簡単に変更されては困るクラスは、accesso rとwriterは使わず、readerを使う

```ruby
class User
    attr_reader :name, :age #これで、initで定義しているnameやageという変数を参照できるようになる
    def initialize(name, age)
        @name = name
        @age = age
    end

    def hello
        "Hello, I am #{@name}、年は#{@age}です"
    end
end

user = User.new("Alice", 20)
p user.hello
p user.name #Alice
p user.age  # 20
# つまり、当引数で入っているデータを確認出来る
```

🔶重要🔶：initで設定した、変数を中で使うということを基本として、accessorを付ければ（:name, :ageなど）、同じくメソッドという扱いでnameとageを使える。主役はあくまでもinitのインスタンス変数

## クラスメソッド

★インスタンスメソッドは、そのクラスから作成されたオブジェクトに対して呼べる（user = User.newのuserにから呼べる）  
🔶重要🔶：クラスメソッドは、クラス自体から直接呼べる（user = User.create_users(namesのcreateのところ）

①クラスの中のメソッドをクラスメソッドにするには、クラスのインスタンスメソッドの頭にself.を付けるか、class << self~end 中にメソッドを記述
⇒class << selfなら、いちいちメソッドにself.を付けなくてもその中にあるメソッドはクラスメソッドになる

```ruby
class User
  class << self
    #この中のメソッドは全てクラスメソッド
  end
end
```

②🔶超重要🔶：つまり、.newされてない「user」とcreate_users()を呼び出している「user」おそらく違う。前者は、「インスタンス」だが、後者はそのクラスのメソッドを発動して代入しているにすぎないので「ただの変数代入」。
⇒おそらく、selfを付けることでインスタンスメソッドとの差別化をしている。selfはそのクラス自分自身を指している。
⇒🔶重要🔶：なぜこんなことをするのかは、本によると「ひとつひとつのインスタンスに含まれるデータは使わないメソッドを定義したいとき」らしい
⇒User.create_usersのこのメソッドは、厳密にいうと「selfによってクラスオブジェクトの特異メソッド」を定義していることになるらしい

```ruby
class User
    def initialize(name)
        @name = name
    end

    def self.create_users(names) # selfはUserを指している
      names.map do |str|
        User.new(str) #selfでUserを指しているから、自身で自身を呼ぶこともできる
      end #こうすれば、initの引数に合わせて引数を付けなくてもいいか？
    end

    def hello #こっちはインスタンスメソッド
        "Hello, I am #{@name}、年は#{@age}です"
    end
end

names = ["alice", "bob", "carol"]
user = User.create_users(names) #形としては変数代入だが、中身は、このメソッド内で.newをしているのでオブジェクトを作成したものが入っている？
user.each do |obje|
  puts obje.hello #作成されたオブジェクトが今回なら３つ入って、それぞれのインスタンスメソッドを呼び出している
end
```

★定数について
⇒定数に関しては、selfを付けたクラスメソッド内でも、インスタンスメソッド内でも普通に記述して使える

```ruby
class Product
  DEFAULT_PRICE = 0
  attr_reader :name, :price
  def initialize(name, price = DEFAULT_PRICE) #これでデフォルトが入っているので、当て引数が、name分だけしかなくても引数エラーにならない
    @name = name
    @price = price
  end
end

product = Product.new("A free movie")
p product.price #ゲッターで値を確認してみると、本引数にデフォルト設定しているのでその引数が無くても「０」と入っている
```

### P223の補足と概要

①１５０円の切符を購入するを「ticket = Ticket.new(150)」  
②梅田という改札口を「umeda = Gate.new(:umeda)」。改札口というオブジェクトをつくっておく  
③十三という改札口を「juso = Gate.new(:juso)」。  
④中身はとにかく、umedaというインスタンスが持っている（Gateクラスに設定した）enterメソッドを使って入り、同じくGateクラスにあるexitメソッドを使って、出場した何らかの値をjusoインスタンスに渡す。そして、jusoの値とumedaの150の関係が真になればテストは通る。  
※ここで重要なのは、Gateオブジェクトというものが今回やりたいことがまとめて利用できる立ち位置にあるということ  
⇒また、作ったインスタンスのメソッドを呼ぶ時に、その引数に別のインスタンスを丸々入れて、中でその別のインスタンスのメソッドを入れられること。

```ruby
class Gate
    STATIONS = [:umeda, :juso, :mikuni]  #このSTATIONとFARESは定数
    FARES = [150, 190]
    def initialize(name) #nameに入ってきた:umedaなどを@nameに格納して使えるようにする
        @name = name
    end
    
    def enter(ticket)#ここに入ってきたのは、ticketインスタンス丸々。だから、そのticketインスタンスのstampメソッドは当然呼べる。重要なのが、umedaインスタンスのインスタンスメソッドに別のインスタンスを丸々入れれば、umedaインスタンスの中でticketインスタンスメソッドが使える上に、そのticketインスタンスのメソッドの引数にumedaインスタンスが最初にinitを通じて格納していた@name（:umeda）を当てることができるということ
       ticket.stamp(@name) #このenterメソッドの返り値は、ticketクラスでattr_readerしている@stamped_at
    end

    def exit(ticket)
        fare = calc_fare(ticket)
        fare <= ticket.fare
    end

    def calc_fare(ticket)
        from = STATIONS.index(ticket.stamped_at) #Ticketクラスのattrで@stamped_atをstamped_atとして呼べるようにしてある。
        to = STATIONS.index(@name) #ここは十三の中の話だから、:jusoが入る 
        distance = to - from #indexメソッドなので数字が入っている
        FARES[distance - 1] #indexは0番目から始まるので１を引く
    end
end

class Ticket  #attr_readerおかげで、umedaインスタンスの変数をjusoインスタンス内で呼べる
    attr_reader :fare, :stamped_at
    def initialize(fare)
        @fare = fare
    end
    
    def stamp(name)
        @stamped_at = name
    end
end
umeda = Gate.new(:umeda) #ここでは、ただ:umedaというデータを入れているだけ
juso = Gate.new(:juso) #150というデータを入れているだけ  
ticket = Ticket.new(150)
umeda.enter(ticket) #ここが本番。ticketというインスタンスを丸々umedaのインスタンスメソッドの引数に当てている
p ticket
# このumeda.enterをした後のticketには、<Ticket:0x00007fffebd10798 @fare=150, @stamped_at=:umeda>が入っている
assert juso.exit(ticket) #なのでここのticketには、fare150とstamped_at = :umedaというデータが入っている
# つまりumeda.enterというのは、ticketインスタンスに:uemedaというデータ入れるコードということ（おもいっきりumedaインスタンスに何かをするという形に見えるが。因みに、p umedaをやると@name = :umedaしか入ってない）
#umedaというインスタンスは、ticketインスタンスに:umedaというデータを入れるため（ticketインスタンスの@stamped_atにデータを入れるためのもの）
```

## selfについて

★selfの効果について  
①クラス内のインスタンスメソッドにselfを付けるとクラスメソッドになる（user = User.create_users(names)）

②attr_accessorで設定したメソッド（:name）をインスタンスメソッド内で使う時に、そのインスタンスメソッドの内容が、そのメソッドに対して、内容を変更するという内容であった時（name = "bob"）に、nameだけだとだたのローカル変数として扱われてしまうので、selfを付けてあげると、selfがname=（セッター）を呼んでくれるのでnameメソッドの中身を変更できる（P234）
🔺注意🔺:selfの付け忘れはよくしやすいので注意らしいが、業務に直結しないとわからないだろう

③selfがどこにあるかでselfの指す内容が変わる
⇒クラスのインスタンスメソッドに付けば（def self.hello）、直接クラスから呼べる

⇒クラス直下、つまり、インスタンスメソッドに付いているのではなく、そのselfがclassの中で直下に浮いている場合は、クラスが定義がされた時に動く

```ruby
class User
    self
end
p User
# User
# selfはクラス名そのものを指す
#この場合は、Userというクラスができて、そのものを呼ぶ時に、直下のselfを出力。直下のselfがクラスを指すなら、P selfとやっているともいえる。
```

④最後にインスタンスメソッド内でselfが呼ばれると、selfが指すのは「Userクラスのインスタンス」

```ruby
class User
    def hello
        self
    end
user = User.new
p user.hello
# <User:0x00007fffbc6eac30>
```

⑤例として、「自身のクラスメソッドを自身のインスタンスメソッドの中で使う」

```ruby
class User

    def self.hello #クラスメソッド
        "hello"
    end

    def greeting #インスタンスメソッドの中でクラスメソッドを使う
        puts User.hello
    end
end
user = User.new
user.greeting
# hello greetingにputsがあるのでpは要らない
```

## クラスの継承

★｜Product｜←｜DVD｜
⇒基本は、スーパークラス（Product）の下がサブクラスで矢印を付けて表記する
🔺注意🔺:「継承は、スーパークラスの全てを引き継ぐ」という目線では見ないこと。継承を使う時のルール
◍🔶重要🔶「サブクラスはスーパークラスの一種である（サブクラス is a スーパークラス）」といったときにその関係に違和感が無ければOK（DVDは商品の一種である）

◍rubyでは、継承は単一継承。継承できるスーパークラスは基本一つだけ（ミックスインはまた別）

★|BasicObject| ← |Object| ← |String, Numeric, Array, Hash|
|Numeric| ← |Integer, Float, Rtional, Complex|

⇒継承の頂点にいるのは、BasicObject

◍**自身で作った**クラスはデフォルトでObjectクラスを継承している(class User end)
⇒なのでObjectクラスのメソッドである、to_sやnil?を使うことができる

★どのクラスに継承しているかは、メソッドを使う

```ruby
user = User.new
user.instance_of?(User)
# userはUserのインスタンスか？ true
user.instance_of?(String)
# これば、false
```

★継承のさせ方

```ruby
class DVD < Product
end
```

### superについて

★単純に継承の例
⇒注目は、User_bookのinitに、Userと同じことを書いている。これはsuperで引き出せる  
⇒因みに、クラスを継承するとそのスーパークラスのクラスメソッドも使える  
（Userクラスのdef self.helloをUser_book.helloとして使える）  
🔺注意🔺:サブクラスの中で、スーパークラスと同じインスタンス変数を使ってしまうと、オーバーライドされてしまうので、必ずスーパークラスのインスタンス変数とインスタンスメソッドに被りがないチェックする

```ruby
class User
    def initialize(name, age)
        @name = name
        @age = age
    end

    def check
        "私は#{@name}で、#{@age}才です"
    end
end
user = User.new("太郎", 20)

class User_book < User
    def initialize(name, age, book)
        @name = name
        @age = age
        @book = book
    end

    def check_book
        "借りた本は、#{@book}, 名前と年齢：#{@name}、#{@age}才"
    end
end

user_book = User_book.new("里子", 19, "世界地図")
p user_book.check_book
```

```ruby
class User
    def initialize(name, age)
        @name = name
        @age = age
    end

    def check
        "私は#{@name}で、#{@age}才です"
    end
end
user = User.new("太郎", 20)

class User_book < User
    def initialize(name, age, book)
        super(name, age)
        @book = book
    end

    def check_book
        "借りた本は、#{@book}, 名前と年齢：#{@name}、#{@age}才"
    end
end

user_book = User_book.new("里子", 19, "世界地図")
p user_book.check_book

```

⇒ここでは、UserとUser_bookの初期引数の数が違うが、同じ内容の引数ならそのままUser_bookのinitの中身は「super」だけでよい

★オーバーライド
⇒サブクラスでは、スーパークラスにあるインスタンスメソッドと同じ名前メソッドを定義すると上書き（オーバーライド）できる

```ruby
class User
 # 省略
end

class User_book < User
    def initialize(name, age, book)
        super(name, age)
        @book = book
    end

    def check_book
        "借りた本は、#{@book}, 名前と年齢：#{@name}、#{@age}才"
    end

    def check
        puts "hello"
    end
end
user_book = User_book.new("里子", 19, "世界地図")
user_book.check
# hello Userと同じcheckメソッドのオーバーライド
# 因みに、initも同じくUser_bookに記述しているのでオーバーライドになっている
```

## メソッドの公開レベル（public,protected,private）

★publicは、クラスの外部からでも自由に呼び出せる。initメソッド以外は、デフォルトでpublic扱いになる

★privateは、クラスの内部でのみ使えるメソッド（外部からは呼び出せない)  
🔶重要🔶：見方を変えると、レシーバー指定して呼び出すことが出来ない。  
⇒下記でいうなら、userがレシーバーでhelloがインスタンスメソッドである。（user.hello）

```ruby
class User
  private

  def hello
    "hello"
  end
end
user = User.new
p user.hello
# test.rb:9:in `<main>': private method `hello' called for #<User:0x00007fffe13d9918> (NoMethodError)
```

🔺注意🔺:privateメソッドでは、サブクラス経由だと呼び出せてしまう
⇒スーパーのインスタンスメソッドはprivateなのに、それをサブクラスの式展開で出せてしまう
⇒下記でサブクラスにhelloメソッドを記述するとオーバーライドもできてしまう（🔺注意🔺：事故につながる）
🔺超注意🔺:つまり、継承を行うときは、必ずsuperのクラス内容を把握していないと事故になるということ
🔺さらにさらに注意🔺:実はprivateメソッドの適用は、「インスタンスメソッド」だけ！クラスメソッドは適用されない。なので、クラスメソッドをprivateにしたい時は、class << selfを使う。この中にあればできる。

```ruby
class User
    private
  
    def hello
      "こんにちは"
    end
end

class Greeting < User
    def greeting
        "#{hello}"
    end
end
greet =  Greeting.new
p greet.greeting 
# "こんにちは"
#メソッドをhelloとgreetingに書いてもnilになる
```

★privateの下にpublicと付ければ、その下は、publicになる。また、privateはメソッドなので引数を渡すことができる  
⇒private :foo, :barと渡すとそのメソッドをprivateにできる

★protectedメソッド
🔶重要🔶：privateとの違いは、「サブクラスと同じクラス内であればレシーバー付きで呼び出せる」
⇒外から、インスタンスから直接プロパティを呼べないが、インスタンスの中なら呼べる
～private～
①class << selfにしない限り、クラスメソッドは呼び出せる  
②サブクラス自身がスーパーのメソッドを仕込んで呼び出すことは可能（サブの式展開にスーパーのメソッドがある）  

```ruby
# ここで整理
class User
    def initialize(name, age)
        @name = name
        @age = age
    end

    def check
        "私は#{@name}で、#{@age}才です"
    end
end
user = User.new("太郎", 20)
p user.name # エラー。@name = 太郎などエラー中身は表示されるけど
#この、.nameはプロパティを呼んでいる
# user.@nameは出来ない。（直接変数を読むには、メソッド経由ではいけない）
# attr_reader :nameを付けるとuser.nameは参照できる
```

★本題  
🔺注意🔺：下記のweightはメソッドではなくプロパティを呼んでいる。

```ruby
class User #体重を公開するのは恥ずかしいので、外部から取得できるのはnameのみ
    attr_reader :name
    def initialize(name, weight)
        @name = name
        @weight = weight
    end
    #何らかの理由で体重を比較しないといけない
    def heavier_than?(other_user) #自分がother_userより重いならtrue
        other_user.weight < @weight
    end
end
alice = User.new("alice", 50)
bob = User.new("bob", 60)
alice.heavie_than?(bob)
# エラー：attr_readerのnameプロパティしか呼べない。途中のweightは設定されてない
```

問題：  
①weightをpublicにしてしまうとother_userの体重を取得できるが、自身の体重も取得できてしまう
⇒attr_reader :weightにすると参照できてしまう。

②体重をprivateの中に置くと、上記のuser.nameはできない、つまり、bob.weighはできない。上記のコードは、クラスの中で、クラスを呼んでいるが同じこと（other_user.weight = bob.weigth）

解決：  
⇒なので外部には公開したくないが、weigthをレシーバとして呼べる方法としてprotectedがある

```ruby
#確認
class User 
    attr_reader :name
    def initialize(name, weight)
        @name = name
        @weight = weight
    end
    
    protected

    def hello
       "こんにちは"
    end
end
alice = User.new("alice", 50)
bob = User.new("bob", 60)
p alice.hello
# これは、privateと同じエラーになる
```

```ruby
class User #体重を公開するのは恥ずかしいので、外部から取得できるのはnameのみ
    attr_reader :name
    def initialize(name, weight)
        @name = name
        @weight = weight
    end
    #何らかの理由で体重を比較しないといけない
    def heavier_than?(other_user) #自分がother_userより重いならtrue
        other_user.weight < @weight
    end

    protected

    def weight # ゲッターだが、protectedされているのでクラスの内の中で呼ぶことができる。外からは参照できない
        @weight
    end
end
alice = User.new("alice", 50)
bob = User.new("bob", 60)
p alice.heavier_than?(bob) # false
p bob.heavier_than?(alice) # true
```

★以下でも可能

```ruby
attr_reader :naem, :weight
~~~~
protected :weight
```

## 定数について

★定数は、クラス内では普通に変数として呼べる。クラスの**外**から呼ぶ時には「クラス名::定数名」と呼ぶ  
◍クラスのインスタンスメソッドを表記する場合は、「クラス名#メソッド名」（String#to_i）  
◍クラス自体のクラスメソッドを表記する場合は、「クラス名.メソッド名 か クラス名::メソッド名」（File::exist?）  
🔺注意🔺:定数は、クラス内のインスタンスメソッドの中では、作成するとエラーになるので、必ずクラス直下で作成する

🔺注意🔺:「定数」は変更しなくていい値を収納する時に使うが、、なんとそのままだと再代入が出来てしまう。  
⇒やり方は、定数を定義した後、その下に同じ定数名前の定数を置いて違う値を入れる。  
⇒または、クラス外部から同じ名前に再代入

```ruby
class Product
  DEF = 0
  DEF = 100
end
p Product::DEF # 100
p Product::DEF = 200 # 200
```

⇒クラス外部からの再代入を防ぐには、freezeメソッドを使う  
🔺注意🔺:しかしこれでは、その後のメソッドの定義もできなくなるので普通はやらない

```ruby
Product.freeze
Product::DEF = 1000 #エラー
```

🔺注意🔺:ミュータブルなオブジェクトは定数の値を変えられる
⇒イミュータブル：数値(integer,float),symbol,true,false,nil
⇒ミュータブル：文字列や配列、ハッシュで**破壊的な変更の適用**ができる（P124）
🔶重要🔶：つまり、破壊的なメソッド（！を付ける）ではなければ、変更されない
⇒ただし、、Array.newの形は、あくまでも同じオブジェクトを参照しているので、独立させる方法も覚えておく
（a = Array.new(5) {"def"}  これで独立した要素が入ったコードになる。この方法なら、破壊的なメソッドでも変更されない）

```ruby
a = Array.new(5, "def")
# ["def", "def", "def", "def", "def"]
str = a[0].upcase!
p str # DEF
p a # ["DEF", "DEF", "DEF", "DEF", "DEF"]

a = Array.new(5, "def")
# ["def", "def", "def", "def", "def"]
str = a[0].upcase
p str # DEF
p a # ["def", "def", "def", "def", "def"]
# 破壊的ではないので変更されてなく、きちんと独立している
```

★下記の定数に再代入し、内容が変わってしまっているhash

```ruby
class Hash_model
    HASH = { foo: 100, bar: 200, buz: 300}
end
Hash_model::HASH[:nya] = 400
p Hash_model::HASH
# {:foo=>100, :bar=>200, :buz=>300, :nya=>400}
```

★また、インスタンスメソッドをクラスメソッドにして、そのメソッドの引数にデフォルト引数として、定数を置いて、そのメソッドの中でその定数の中身を消すようなメソッドがあれば、やはりその中身も変わってしまう。

```ruby
class Product
  SOME = ["foo", "bar", "baz"]

  def self.delete_name(names = SOME)
    names.delete("foo")
  end
end
Product.delete_name
p Product::SOME
# ["bar", "baz"]
```

🔶重要🔶：このような時は、直接定数に.freezeをかけると「SOME」自体の全体の変更はできなくなるが、SOME[0].upcase!などの中身の一部は変更できてしまう。なので、中身も["foo".freeze, "bar".freeze, "baz".freeze].freezeとすれば完璧だが、これは大変。なので、mapメソッドを使う。  
⇒イミュータブルはfreezeする必要なし

```ruby
class Product
    SOME = ["foo", "bar", "baz"].freeze
    
    SOME.map do |str|
        str.freeze
    end
end
p Product::SOME[0].upcase!
# test.rb:8:in `upcase!': can't modify frozen String: "foo" (FrozenError)
# リファクタリング
class Product
   SOME = ["foo", "bar", "baz"].map(&:freeze).freeze
end
```

## 様々な種類の変数

① @nameはインスタンス変数だが、インスタンスメソッドの中に@nameを入れて、インスタンスメソッドにselfを付けるとその@nameはクラスインスタンス変数になる

②🔺注意🔺:クラスインスタンス変数（@name）とクラス変数はちがう（@@name）

```ruby
class User
  @name = name #クラス直下なので、これはクラス変数

  def self.hello #これは、クラスから直接呼べるので、クラスインスタンス変数
    @name
  end

  def greeting #インスタンス（user = User.new）から呼べるインスタンスメソッドであり、ゲッターであり、インスタンス変数
    @name
  end

  def initialize(name)
    @name = name #intiの@nameもインスタンス変数だが、private
  end
end
```

🔺注意🔺: サブクラスのインスタンスメソッド名をスーパーと同じにするとオーバーライドされる。クラスインスタンスは、別々に管理される。また、クラスインスタンス変数は、**インスタンスメソッド内で共有されることはなく**、サブとスーパーで同じ名前のクラス変数があっても、別々に管理される。

```ruby
class User
    @name = "hello"
    def self.name #クラスインスタンス変数
        @name
    end

    def initialize(name) # インスタンス変数
        @name = name
    end

    def up
        @name.upcase
    end
end

class User_book < User
    @name = "こんにちは"
    def self.name
        @name
    end
end
p User.name #クラスインスタンス変数は、変わらず"hello"
user = User.new("alice")
p user.up  #"ALICE"
#クラスインスタンス変数とインス変数は別々
p User_book.name
#"こんにちは"
```

🔺注意🔺:ただし、@@を二つ重ねたクラス変数はサブとスーパーで共有され、インスタンスメソッド内でも共有される。共有できるというのは、クラス変数の内容をインスタンス変数に入れることができる

```ruby
class User
    @@name = "hello"
    def self.name
        @@name
    end
end
class User_book < User
    @@name = "こんにちは"
    def self.name
      @@name
    end
end
p User.name # こんにちは
# User_book < Userで継承し、先ほどのクラスインスタンス変数だとhelloのままだが、「クラス」変数は、Userの@@nameもかわってしまっている
```

🔺注意🔺:最後に＄で始まるグローバル変数は、外部からも内部からも参照、変更できる変数だが基本使わない
⇒正規表現の組み込み変数の「＄」と混ざって分かりにくいなどもある

## ネストしたクラスの定義

★定数は、クラスの**外**から呼ぶ時には「クラス名::定数名」と呼ぶ  
◍クラスのインスタンスメソッドを表記する場合は、「クラス名#メソッド名」（String#to_i）  
◍クラス自体のクラスメソッドを表記する場合は、「クラス名.メソッド名 か クラス名::メソッド名」（File::exist?）  

★そして、ネストは、定数と同じく「::」を使って呼ぶ
🔺注意🔺:これは名前空間を考えるときに使う、クラスより、モジュールを使った方が分かりやすいかも

```ruby
class User
    def initialize(age)
        @age = age
    end
    def age_model
        @age
    end
    class Child
        def initialize(name)
            @name = name
        end

        def name_model
            @name
        end
    end
end

user = User.new(19)
p user.age_model # 19
child = User::Child.new("太郎")
p child.name_model # 太郎
```

## モンキーパッチ

★外部ライブラリなどの既存の実装を上書きして、自分が期待する挙動に変更することをいう  
⇒ほぼオーバーライドのことを指すが、あるクラスにあったメソッドをもっと使いやすいように変更改良していくのがモンキーパッチ  
⇒つまり、既存のメソッドが使いずらいと思ったら、クラスをもう一度書いてそのメソッドを対象に中身を変更してあげる
⇒因みにaliasメソッド（alias 新しい名前 前の名前）でメソッド名を変えることもできる
(alias greed greeding)

🔺注意🔺:  
①不適切にやると、プログラムが動かなくなる
②他の人がわからない
③ライブラリのバージョンアップをしたら整合性がとれなくなる

```ruby
class User
   def initialize(name)
       @name = name
   end

   def greeding #名前だけしか表示しない
       @name
   end
end

class User
    def greeding 
        "私の名前は、#{@name}です" #文章をつけてみたかった
    end
end

user = User.new("太郎")
p user.greeding
#"私の名前は、太郎です"
# これでgreedingというメソッドが華やかになった
```

## 特異メソッド

★特定のオブジェクトにだけ紐づくメソッドを指す(def alice.shuffle)
⇒別の見方をすると、aliceという変数にshuffletestというメソッドを追加した。I am aliceというプロパティとshuffletestを持ったオブジェクトである。つまり、特定のオブジェクト（alice）にsuffletestという特異メソッドを追加した。  
⇒クラスメソッドを作った時にやった、class << selfの真似で、class << aliceという形もできる。実は、クラスメソッドは、直接クラスについているメソッドだが、その関係、特定のクラスが使えるメソッドなので、クラスメソッドは特異メソッドである。  
⇒そうするとクラスメソッドはそのクラスの外で特異メソッドとしてつけることもできる（下記参照）  
⇒クラスメソッドはRubyのAPIドキュメントでは、特異メソッドとして書かれている  
🔺注意🔺:ただし、数値をシンボルだけは特異メソッドと追加できない。

```ruby
alice = "I am alice"
def alice.shuffletest
    chars.shuffle.join
end
# "ai amlI ec"

alice = "I am alice"
class << alice
    def shuffletest
        chars.shuffle.join
    end
end
p alice.shuffletest
```

```ruby
class User
    def initialize(name)
    @name = name
    end

    #def self.human とここでクラスメソッドを定義してもいいが

    def hello #インスタンスメソッド
        "hello"
    end
end
def User.human
    "人間"
end
p User.human #人間
```
