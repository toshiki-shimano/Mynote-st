# Railsコンソールにおいて出来ること

①オブジェクトの作り方  
⇒  user  =  User.new(name: "admin",  email: "slimslim@au.com", admin: true, password: "aaabbb", password_confirmation: "aaabbb")

②作ったオブジェクトにおいて、エラーの原因をわかりやすくしたい時。  
⇒note.errorsだと長いエラー文だが、note.errors.full_messagesだとそのエラーだけがきれいに出る

③作ったオブジェクトが保存されているか？  
⇒note.persisted? コマンドでfalseかtrueが出る

④タスクやユーザーの全削除（DBに余計なデータが残っている場合）
⇒rails cでコンソールに入り、`Note.delete_all`で消せる。
