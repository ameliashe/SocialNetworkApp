//
//  File.swift
//  Navigation
//
//  Created by Amelia Romanova on 11/14/24.
//

import Foundation
import FirebaseFirestore

public struct Post: Codable {
	public let authorID: String
	public let description: String
	public let image: String
	public let likes: Int
	public let views: Int
	public let postTime: Int
}

public let posts: [Post] = [
	Post(
		authorID: "anna_zaitseva",
		description: "Breathtaking sunset views. Yesterday the weather was perfect, and I took a few nice pics of the lake.",
		image: "https://unsplash.com/photos/aT3VvFtsEQ8/download?force=true",
		likes: 121,
		views: 430,
		postTime: 1744243200
	),
	Post(
		authorID: "boris_yegorov",
		description: "I love cooking! Today's experiment was a success: I tried a new seafood pasta recipe. Everyone who tasted it was amazed – I'll definitely be making it again!",
		image:  "https://unsplash.com/photos/k8FXgsDTm8g/download?force=true",
		likes: 2,
		views: 210,
		postTime: 1745280000
	),
	Post(
		authorID: "cindy_xie",
		description: "Traveling is always an adventure!",
		image:  "https://unsplash.com/photos/zRe_7Yu5JP4/download?force=true",
		likes: 145,
		views: 500,
		postTime: 1746403200
	),
	Post(
		authorID: "dave_wright",
		description: "A walk in the woods is the best remedy for the hustle and bustle. Today I discovered a cozy spot by the river where you can sit in silence and enjoy nature. Moments like these help you reset.",
		image:  "https://unsplash.com/photos/ssEQdOiKd8U/download?force=true",
		likes: 0,
		views: 250,
		postTime: 1747526400
	),
	Post(
		authorID: "fiona_underwood",
		description: "Today I visited a contemporary art exhibition and I really loved the combination of contrast colors and minimalism in the artists' works.",
		image:  "https://unsplash.com/photos/pVmCu79zk0Q/download?force=true",
		likes: 60,
		views: 180,
		postTime: 1748908800
	),
	Post(
		authorID: "eugene_vlasov",
		description: "Yesterday I tried a new variety of tea – oolong with light floral notes. Not only does it have a pleasant taste, but it also helps you relax after a long day. Definitely my new favorite for evening tea sessions!",
		image:  "https://unsplash.com/photos/p99ZKwVGBRA/download?force=true",
		likes: 75,
		views: 300,
		postTime: 1750982400
	),
	Post(
		authorID: "boris_yegorov",
		description: "Whipped up some homemade sourdough bread today — the aroma filled the entire kitchen!",
		image: "https://unsplash.com/photos/y7x_TQO5XP0/download?force=true",
		likes: 45,
		views: 120,
		postTime: 1743811200
	),
	Post(
		authorID: "anna_zaitseva",
		description: "Sunrise run by the riverside gave me all the positive vibes for the week ahead.",
		image: "https://unsplash.com/photos/7DXmFf4Nt54/download?force=true",
		likes: 89,
		views: 230,
		postTime: 1746748800
	),
	Post(
		authorID: "fiona_underwood",
		description: "Caught the golden hour glow in the city — architecture has never looked so magical.",
		image: "https://unsplash.com/photos/gy6wOjj1Kws/download?force=true",
		likes: 102,
		views: 315,
		postTime: 1744934400
	),
	Post(
		authorID: "dave_wright",
		description: "Built a DIY bookshelf over the weekend — nothing beats the satisfaction of handmade furniture.",
		image: "https://unsplash.com/photos/QIOpyrt1mck/download?force=true",
		likes: 66,
		views: 190,
		postTime: 1748304000
	),
	Post(
		authorID: "cindy_xie",
		description: "Discovered a hidden coffee shop down an alley — espresso was perfection!",
		image: "https://unsplash.com/photos/BeRFg1Iisa0/download?force=true",
		likes: 78,
		views: 255,
		postTime: 1749686400
	),
	Post(
		authorID: "eugene_vlasov",
		description: "Tried my hand at watercolor painting — these floral washes are so soothing to create.",
		image: "https://unsplash.com/photos/CwKNTeWvUWE/download?force=true",
		likes: 54,
		views: 140,
		postTime: 1750464000
	),
	Post(
		authorID: "anna_zaitseva",
		description: "Garden harvest is in — picked the ripest tomatoes for tonight’s salad!",
		image: "https://unsplash.com/photos/oXtA-BVgOS4/download?force=true",
		likes: 95,
		views: 260,
		postTime: 1749168000
	),
	Post(
		authorID: "dave_wright",
		description: "Hit the trails with my mountain bike — the adrenaline rush was unreal!",
		image: "https://unsplash.com/photos/1ow9zrlldJU/download?force=true",
		likes: 81,
		views: 275,
		postTime: 1745971200
	),
	Post(
		authorID: "boris_yegorov",
		description: "Experimented with homemade sushi rolls — result: restaurant-quality dinner at home.",
		image: "https://unsplash.com/photos/Ynxx-NiZ9lY/download?force=true",
		likes: 58,
		views: 205,
		postTime: 1747180800
	),
	Post(
		authorID: "fiona_underwood",
		description: "Strolled through the art district — every mural tells its own story.",
		image: "https://unsplash.com/photos/zSi9Z6QeCQQ/download?force=true",
		likes: 73,
		views: 220,
		postTime: 1750118400
	),
	Post(
		authorID: "cindy_xie",
		description: "Morning yoga session in the park left me feeling centered and energized.",
		image: "https://unsplash.com/photos/HZQXzeQp9g0/download?force=true",
		likes: 91,
		views: 280,
		postTime: 1744416000
	),
	Post(
		authorID: "eugene_vlasov",
		description: "Brewing the perfect cup of matcha at home is my new weekend ritual.",
		image: "https://unsplash.com/photos/v1OW17UcR-Q/download?force=true",
		likes: 47,
		views: 150,
		postTime: 1748476800
	),
	Post(
		authorID: "test",
		description: "Just seen my favorite band perform live! Best night ever",
		image: "https://unsplash.com/photos/TTUjr6s4iNU/download?force=true",
		likes: 25,
		views: 80,
		postTime: 1744819200
	),
	Post(
		authorID: "test",
		description: "Just finished reading a new inspiring book about creativity and I'm so pumped to start working on something new!",
		image: "https://unsplash.com/photos/3uqauucYhjQ/download?force=true",
		likes: 14,
		views: 60,
		postTime: 1747814400
	),
	Post(
		authorID: "test",
		description: "Spent the afternoon hiking in the hills. The views were absolutely stunning!",
		image: "https://unsplash.com/photos/CwGQwBjSjhY/download?force=true",
		likes: 37,
		views: 120,
		postTime: 1748688000
	),
	Post(
		authorID: "test",
		description: "Baked a batch of chocolate chip cookies—kitchen smells heavenly.",
		image: "https://unsplash.com/photos/YDvfndOs4IQ/download?force=true",
		likes: 19,
		views: 55,
		postTime: 1750387200
	),
]
