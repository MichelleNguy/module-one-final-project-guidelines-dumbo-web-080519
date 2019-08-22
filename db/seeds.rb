User.destroy_all
Match.destroy_all
Bet.destroy_all

tom = User.create(name: "tom", password: "mom", funds: 1000)
jerry = User.create(name: "jerry", password: "mom", funds: 500)

m0 = Match.create(date: "08/19/2019", stadium: "Yankee Stadium", home_team: "Yankees", away_team: "Astros", home_score: 0, away_score: 2)
m1 = Match.create(date: "08/24/2019", stadium: "Dodgers Stadium", home_team: "Dodgers", away_team: "Angels")
m2 = Match.create(date: "08/25/2019", stadium: "Minute Maid Park", home_team: "Astros", away_team: "Athletics")
m3 = Match.create(date: "08/26/2019", stadium: "Fenway Park", home_team: "Red Sox", away_team: "White Sox")
m4 = Match.create(date: "08/26/2019", stadium: "Wrigley Field", home_team: "Cubs", away_team: "Twins")

b1 = Bet.create(user_id: tom.id, match_id: m0.id, amount: 100, for: m0.home_team, grade: "Won", status: "Graded")
b2 = Bet.create(user_id: tom.id, match_id: m1.id, amount: 100, for: m1.home_team, status: "Pending")
b3 = Bet.create(user_id: jerry.id, match_id: m1.id, amount: 100, for: m1.away_team, status: "Pending")

puts "Seeded"



