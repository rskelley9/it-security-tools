About
-----

This brute-force password cracker uses [gentle_brute](https://github.com/jamespenguin/gentle-brute), a library to crack MD5 hashed passwords.

Test Run
--------

Install Dependencies
```
$ bundle install

```

Crack Test Password

```
$ ruby simple_pass_cracker.rb [password hash]
```

Test Gentle Brute:
```
$ wget https://raw.github.com/jamespenguin/gentle-brute/master/passwords.txt

$ GentleBrute --crack-md5-list passwords.txt
```