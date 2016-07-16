# Homepage (Root path)
get '/' do
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

get '/question' do
  @question = Question.find_by(player_id: Player.last.id).question
  erb :question
end




