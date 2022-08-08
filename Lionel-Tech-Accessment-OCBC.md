# Lionel Tech Accessment OCBC

### YOU ARE REQUIRED TO HAVE XCODE TO RUN THIS FILE

## Features
1. Login
2. Topup for current user
3. Pay other user
4. Ledger (Debt) System
5. Auto Pay when user top up

## Commands
```sh
login XXX
```
 XXX user will be created if its not existed else make this user
 
 ```sh
pay XXX YY
```
 payment flow where XXX is the user name and YY is the amount in Int
 
 ```sh
topup YY
```
 topup current user balance with YY (as Int)

## Assumptions
1. If u want to create a user like 'Alice' make sure its 'Alice' not 'alice' as it will be create two user
2. Every run of the build will remove the existing users because of no database being configured

