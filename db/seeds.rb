User.destroy_all
Match.destroy_all
Bet.destroy_all

tom = User.create(name: "tom", password: "mom", funds: 1000)
jerry = User.create(name: "jerry", password: "mom", funds: 500)

m0 = Match.create(date: "08/19/2019", stadium: "France Stadium", home_team: "France", away_team: "Brazil", home_score: 0, away_score: 2)
m1 = Match.create(date: "08/24/2019", stadium: "New York Stadium", home_team: "USA", away_team: "Germany")
m2 = Match.create(date: "08/25/2019", stadium: "California Stadium", home_team: "USA", away_team: "Netherlands")

b1 = Bet.create(user_id: tom.id, match_id: m0.id, amount: 100, for: "Brazil", grade: "Won", status: "Graded")
b2 = Bet.create(user_id: tom.id, match_id: m1.id, amount: 100, for: "USA", status: "Pending")
b3 = Bet.create(user_id: jerry.id, match_id: m1.id, amount: 100, for: "Germany", status: "Pending")

puts "Seeded"



