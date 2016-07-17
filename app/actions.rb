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

get '/question/:question_order' do
  @question_order = params[:question_order].to_i - 1
  @question = Question.order(:id)[@question_order]
  @player = Player.find(@question.player_id)
  @other_players = Player.where.not(id: @player.id)
  @answer = Answer.new
  @all_answer = Answer.where(question_id:@question.id)
  erb :question
  
end

post '/question/:question_order/answers' do 

  @answer = Answer.create(
    question_id: params[:question_id],
    answer: params[:answer],
    player_id: params[:other_player_id]
    )
  
  if Answer.where(question_id: params[:question_id]).count < (Player.all.count - 1)
    redirect "/question/#{params[:question_order]}"
  else
    redirect "/question/#{params[:question_order]}/pass"
  end

end

get '/question/:question_order/pass'do 
  @question_order = params[:question_order].to_i - 1
  @question = Question.order(:id)[@question_order]
  # @question = Question.find(params[:question_id])
  # binding.pry
  @player = Player.find(@question.player_id)
  erb :'/players/pass'
end

get '/question/:question_order/rank' do 
  @question_order = params[:question_order].to_i - 1
  @question = Question.order(:id)[@question_order]
  # @question = Question.find(params[:question_id])
  @answers_all = Answer.where(question_id: @question.id)
  erb :'/players/rank'
end

post '/question/:question_order/ranked' do 
  # params[:12] = 500
  # binding.pry
  @question_order = params[:question_order].to_i - 1
  @question = Question.order(:id)[@question_order]
  # @question = Question.find(params[:question_id])
  @player = Player.find(@question.player_id)
  @other_players = Player.where.not(id: @player.id)

  @other_players.each do |player|
    the_id = player.id
    player.points += params[(the_id.to_s)].to_i
    player.save
  end

  redirect "/question/#{@question_order + 1}/result"
end

get '/question/:question_order/result' do 
  @question_order = params[:question_order].to_i - 1
  @all_players = Player.all.order(points: :desc)
  @next_question = params[:question_order].to_i + 1

  if params[:question_order].to_i < @all_players.count
    erb :'/players/result'
  else
    redirect '/final_result'
  end

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

post '/play_again' do 
  @all_players = Player.all
  @all_questions = Question.all
  @all_answers = Answer.all

  @all_players.each do |player|
    player.destroy
  end

  @all_questions.each do |player|
    player.destroy
  end

  @all_answers.each do |player|
    player.destroy
  end

  redirect '/'
end

