# CrackThemAll

## Usage
```ruby
./cracker.sh -h

[*] Uso: ./cracker.sh -f ./hashes.txt -p hashcat -m ntlm -l spanish

        f) Hashes File
        p) Program
                hashcat
                john
        m) Hash Mode
                ntlm
        l) Language Mode
                spanish
                english
        u) Url List (Optional)
        h) Help Panel
```
1. clone: `git clone https://github.com/dur4ng/cracker`
2. add corporative keywords to `./dictionaries/<language>/corporative.txt`
3. run the tool `./cracker.sh -f ./hash.txt -p hashcat -m ntlm -l english`
4. run csv2wordTable.ps1 to create a word table for the report

## Entry
- ntlm: `Administrador:500:aaff4cfa4a330j13051c28c7de6bb216:b4b9b02e6f09a9bd760f388b67351e2b:::`

## Objetive
1. make ez and quick the process of generating custom wordlists
2. output the results in a csv with usernames and censured passwords

## Wordlist generator
1. create wordlists
2. Merge wordlists
3. Concatenate words(using princeprocessor)
4. Permute words (using rsmangler)

## Crack passwords
hashes supported:
- ntlm
wordlists used:
    - /opt/wordlists/rockyou.txt
    - /opt/wordlists/kaonahsi.txt
    - /opt/wordlists/hasheorg2019.txt
    - /opt/wordlists/crackstation.txt
    - /opt/wordlists/hashkiller-dict.txt
    - /opt/wordlists/HIBP/pwned-passwords-ntlm-ordered-by-count-v7.txt
    - /opt/wordlists/CompilationOfManyBreachesPasswords.txt
    - ./dictionaries/customWordlist.txt

## Format results
1. censor your passwords
2. export to csv(username;password)

## TODO
- support more hashes
