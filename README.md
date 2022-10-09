# CryptoAssetsApp
CryptoAssetsApp is a sample iOS App displays list of top tier crypto currencies and tracking their price changes in real time.

<p align="center"><img width="300" src="https://user-images.githubusercontent.com/1131493/194743319-3b7d0897-3479-4d35-b2ad-513757353d7a.png"></p>

This application is written by using TDD methodology. All functionalities are covered by unit test. This app also demonstrate how to apply pure MVVM design pattern for presentation layer and others design patterns like Composition, Decorator, Stategy, Observer Patterns.

## Architecture Overview

<p align="center"><img width="300" alt="Screenshot 2022-10-09 at 3 09 33 PM" src="https://user-images.githubusercontent.com/1131493/194743026-2925f363-961f-49b4-a635-bad5b1aa1b5e.png"></p>

* Presentation Layer (MVVM) = ViewModels + Views
* Domain Layer = Entities + Use Cases + Repositories Interfaces
* Data Repositories Layer = Repositories Implementations + API (Network) + Persistence DB

## How to run the project ?
Download the zip file or clone the project, currently there's one master branch.
Run the project using Xcode( change the bundle identifier, if you want to run it on your device).
