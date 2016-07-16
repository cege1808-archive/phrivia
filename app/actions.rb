# Homepage (Root path)
get '/' do
  erb :index
end

post '/players/new' do
  @player = Player.new
  erb :'/players/new'
end

post '/players/new' do
  @player = Player.new(name: params[:name], points: params[:points])
  @player.save
  @question = Question.new(question: params[:question], player_id: params[:player_id])
  @question.save
  redirect '/'
end


