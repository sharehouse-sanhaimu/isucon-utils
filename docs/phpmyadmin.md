# phpmyadminを使う方法

## git cloneをする
cloneしたらexample.envを修正する
```bash
git clone https://github.com/sharehouse-sanhaimu/look-mysql.git
mv example.env env
vim .env
```

で修正する

## mysql側の設定
### アクセス許可を付与

```bash
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```

```diff
- bind-address            = 127.0.0.1
+ bind-address            = <localのIP>
```

```bash
sudo systemstl mysql.service
```



### アクセスできるユーザの作成
```bash
sudo su
mysql -u root
CREATE USER 'super_admin'@'%' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON *.* TO 'superadmin'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```


