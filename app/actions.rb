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
  @question = Question.find_by(player_id: @player.id).question
  erb :question
end


