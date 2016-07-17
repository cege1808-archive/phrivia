# Homepage (Root path)
get '/' do
  @all_players = Player.all
  erb :index
end

get '/players/new' do
  @player = Player.new
  erb :'/players/new'
end

post '/players/new' do
  @player = Player.new(name: params[:name], points: params[:points])
  @player.save
  @question = Question.new(question: params[:question], player_id: @player.id)
  @question.save
  redirect '/'
end

get '/question/one' do
  @player = Player.order(:id)[0]
  @question = Question.find_by(player_id: @player.id)
  @other_players = Player.where.not(id: @player.id)
  @answer = Answer.new
  @all_answer = Answer.where(question_id:@question.id)
  erb :question
  
end

post '/question/:question_id/answers' do 
  @answer = Answer.create(
    question_id: params[:question_id],
    answer: params[:answer],
    player_id: params[:other_player_id]
    )
  
  if Answer.where(question_id: params[:question_id]).count < (Player.all.count - 1)
    redirect '/question/one'
  else
    redirect "/question/#{params[:question_id]}/pass"
  end

end

get '/question/:question_id/pass'do 
  @question = Question.find(params[:question_id])
  # binding.pry
  @player = Player.find(@question.player_id)
  erb :'/players/pass'
end

get '/question/:question_id/rank' do 
  @question = Question.find(params[:question_id])
  @answers = Answer.where(question_id: @question.id)
  erb :'/players/rank'
end

post '/question/:question_id/ranked' do 
  # params[:12] = 500
  # binding.pry
  @question = Question.find(params[:question_id])
  @player = Player.find(@question.player_id)
  @other_players = Player.where.not(id: @player.id)

  @other_players.each do |player|
    the_id = player.id
    player.points += params[(the_id.to_s)].to_i
    player.save
  end

  redirect "/question/#{:question_id}/result"
end

get '/question/:question_id/result' do 
  @all_players = Player.all.order(points: :desc)
  erb :'/players/result'

end

get '/final_result' do 
  @all_players = Player.all
  # binding.pry
  highest_score = @all_players.maximum("points")
  lowest_score = @all_players.minimum("points")
  @highest_scorer = @all_players.find_by(points: highest_score)
  @lowest_scorer = @all_players.find_by(points: lowest_score)
  erb :'final'

end
