//
//  User.swift
//  Navigation
//
//  Created by Amelia Shekikhacheva on 12/15/24.
//
import UIKit

struct User: Codable {
	var login: String
	var fullName: String
	var avatar: String
	var status: String
	var city: String
	var friends: [String]?
	var followers: [String]?
}


var userList: [User] = [
	User(
		login: "test",
		fullName: "Amelia Shekikhacheva",
		avatar: "https://unsplash.com/photos/p6yH8VmGqxo/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8MTQwfHxjYXQlMjByZWR8ZW58MHwyfHx8MTc1MTIxOTYyOXww&force=true&w=640",
		status: "When darkness rolls on you, push on through",
		city: "Paris",
		friends: [
			"anna_zaitseva",
			"cindy_xie",
			"dave_wright",
			"eugene_vlasov"
		],
		followers: [
			"boris_yegorov",
			"fiona_underwood"
		]
	),
	User(
		login: "anna_zaitseva",
		fullName: "Anna Zaitseva",
		avatar: "https://unsplash.com/photos/f4lKgRFUD3M/download?force=true",
		status: "We will, we will rock you",
		city: "Amsterdam",
		friends: nil,
		followers: nil
	),
	User(
		login: "boris_yegorov",
		fullName: "Boris Yegorov",
		avatar: "https://unsplash.com/photos/RiDxDgHg7pw/download?force=true",
		status: "Let it be",
		city: "Belgrade",
		friends: nil,
		followers: nil
	),
	User(
		login: "cindy_xie",
		fullName: "Cindy Xie",
		avatar: "https://unsplash.com/photos/LK9UBaUEEXk/download?force=true",
		status: "May the Force be with you",
		city: "Warsaw",
		friends: nil,
		followers: nil
	),
	User(
		login: "dave_wright",
		fullName: "Dave Wright",
		avatar: "https://unsplash.com/photos/pFstlKzYPNY/download?force=true",
		status: "Seize the day, boys",
		city: "San Francisco",
		friends: nil,
		followers: nil
	),
	User(
		login: "eugene_vlasov",
		fullName: "Eugene Vlasov",
		avatar: "https://unsplash.com/photos/f8qBBrmFUlI/download?force=true",
		status: "Don't stop me now, I'm having such a good time",
		city: "London",
		friends: nil,
		followers: nil
	),
	User(
		login: "fiona_underwood",
		fullName: "Fiona Underwood",
		avatar: "https://unsplash.com/photos/wNLKiFppARM/download?force=true",
		status: "All you need is love",
		city: "Berlin",
		friends: nil,
		followers: nil
	)
]
