# Railsコンソールにおいて出来ること

①オブジェクトの作り方  
⇒  note  =  Note.new(name: "admin",  email: "slimslim@au.com")

②作ったオブジェクトにおいて、エラーの原因をわかりやすくしたい時。  
⇒note.errorsだと長いエラー文だが、note.errors.full_messagesだとそのエラーだけがきれいに出る

③作ったオブジェクトが保存されているか？  
⇒note.persisted? コマンドでfalseかtrueが出る
