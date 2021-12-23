# Products App

A Flutter mobile app that simulates a marketplace, displaying a list of products for sale with prices. It connects to several Firebase services for different functionalities.

## Description

This application uses Firebase services for authentication, and the token is stored locally using Shared Preferences.

After authenticating, the user can manage a list of products for sale that are stored using Firebase Realtime Database. The product description includes a name, image, price and availability status.

Users can add new products by tapping on the (+) button. Each product must have a name and price, and the picture can be added anytime.

## Implemented packages

Some of the most important packages used to build this app are:

 - flutter_secure_storage: ^4.2.1
 - http: ^0.13.4
 - image_picker: ^0.8.4+4
 - provider: ^6.0.1
