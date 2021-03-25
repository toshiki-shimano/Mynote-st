# Gitメモ

* やってはいけない事
⇒git push -f origin master(これは強制的に履歴を書き換える、絶対にしない、自分が解決できても、自身の書き換えた履歴でgithubにpushするわけだから、他の人もfast-forwordedになってリベースでdiffを書き換えらなきょいけなくなる)

⇒masterにpushすること（基本開発環境でmasterにpushすることは無い。必ず自身のブランチにpushする）

⇒注意

⇒git reset soft HEAD^^(^^の分戻す。コミットを二回分戻す。ファイルの内容は消えないので、git diffで変更前変更後が確認できる)
⇒git reset head HEAD^(コミット一回分もどす、ファイルのデータも消えてしまうので自身の開発のみ)
⇒基本はコミットしたら、resetするのではなく修正コミットを出すのが普通
⇒git commit --amendはコミットのコメントを直すだけ
